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
        let carts = JSON.stringify(orderData["carts"]);
        let updatedAt = orderData["updatedAt"].toDate();
        let updatedAtString = updatedAt.getFullYear() +
                                "-" +
                                ("0" + (updatedAt.getMonth() + 1)).slice(-2) +
                                "-" +
                                ('0' + updatedAt.getDate()).slice(-2) +
                                " " +
                                ("0" + updatedAt.getHours()).slice(-2) +
                                ":" +
                                ('0' + updatedAt.getMinutes()).slice(-2) +
                                ":" +
                                ("0" + updatedAt.getSeconds()).slice(-2);
        let createdAt = orderData["createdAt"].toDate();
        let createdAtString = createdAt.getFullYear() +
                                "-" +
                                ("0" + (createdAt.getMonth() + 1)).slice(-2) +
                                "-" +
                                ('0' + createdAt.getDate()).slice(-2) +
                                " " +
                                ("0" + createdAt.getHours()).slice(-2) +
                                ":" +
                                ('0' + createdAt.getMinutes()).slice(-2) +
                                ":" +
                                ("0" + createdAt.getSeconds()).slice(-2);
        console.log(carts);
        console.log(updatedAtString);
        console.log(createdAtString);
        //Xserverに設置してあるPHPを実行
        const post_data = querystring.stringify({
            "id": orderData["id"],
            "number": orderData["number"],
            "shopId": orderData["shopId"],
            "shopNumber": orderData["shopNumber"],
            "shopName": orderData["shopName"],
            "shopInvoiceName": orderData["shopInvoiceName"],
            "carts": carts,
            "status": orderData["status"],
            "updatedAt": updatedAtString,
            "createdAt": createdAtString,
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