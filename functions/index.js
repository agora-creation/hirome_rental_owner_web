const {onSchedule} = require("firebase-functions/v2/scheduler");
const {logger} = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

const querystring = require('querystring');
const https = require("https");

//exports.onceYearFunction = onSchedule("00 0 1 1 *", async (event) => {
exports.onceYearFunction = onSchedule("00 0 * * *", async (event) => {
    let result = await backupToXserver();
});

async function backupToXserver() {
    //Firestoreから2年前の注文データを取得
    let dt = new Date();
    //let searchStart = new Date(dt.getFullYear() - 2, 1, 1, 0, 0, 0);
    //let searchEnd = new Date(dt.getFullYear() - 2, 12, 31, 23, 59, 59);
    let searchStart = new Date(dt.getFullYear(), 1, 1, 0, 0, 0);
    let searchEnd = new Date(dt.getFullYear(), 12, 31, 23, 59, 59);
    let orderQuerySnapshot = await admin.firestore().collection("order").where("status", "==", 1).where("createdAt", ">=", searchStart).where("createdAt", "<=", searchEnd).get();
    orderQuerySnapshot.forEach((orderDoc) => {
        let orderData = orderDoc.data();

        console.log(orderData["carts"]);
        console.log(orderData["updatedAt"]);
        console.log(orderData["updatedAt"]);

        //Xserverに設置してあるPHPを実行
        const post_data = querystring.stringify({
            "id": orderData["id"],
            "number": orderData["number"],
            "shopId": orderData["shopId"],
            "shopNumber": orderData["shopNumber"],
            "shopName": orderData["shopName"],
            "shopInvoiceName": orderData["shopInvoiceName"],
            "carts": String(orderData["carts"]),
            "status": orderData["status"],
            "updatedAt": String(orderData["updatedAt"]),
            "createdAt": String(orderData["createdAt"]),
        });
        const options = {
            protocol: "https:",
            host: "hirome.co.jp",
            path: "/rental/ajax-order.php",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "Content-Length": Buffer.byteLength(post_data)
            },
            method: "POST",
        };
        const req = https.request(options, (res) => {
            let body = "";
            res.on("data", (chunk) => {
                body += chunk;
            });
            res.on('end', () => {
                console.log("応答データはありません");
                console.log(body);
            });
        });
        req.on("error", (e) => {
            console.error("リクエストエラー: " + e.message);
        });
        req.write(post_data);
        req.end();
        //最後にDocを削除
        //orderDoc.ref.delete();
    });
    return "成功";
}