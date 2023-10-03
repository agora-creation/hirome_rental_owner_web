const {onSchedule} = require("firebase-functions/v2/scheduler");
const {logger} = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

//exports.onceYearFunction = onSchedule("00 0 1 1 *", async (event) => {
exports.onceYearFunction = onSchedule("00 0 * * *", async (event) => {
    let result = await backupToXserver();
    console.log(result);
});

async function backupToXserver() {
    let result = "失敗";
    //Firestoreから2年前の注文データを取得
    let dt = new Date();
    let searchStart = new Date(dt.getFullYear() - 2, 1, 1, 0, 0, 0);
    let searchEnd = new Date(dt.getFullYear() - 2, 12, 31, 23, 59, 59);
    let orderQuerySnapshot = await admin.firestore().collection("order").where("createdAt", ">", searchStart).where("createdAt", "<", searchEnd).get();
    orderQuerySnapshot.forEach((orderDoc) => {
        console.log(orderDoc.data());
    });
    return result;
}