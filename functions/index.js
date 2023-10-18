const {onSchedule} = require('firebase-functions/v2/scheduler');
const {logger} = require('firebase-functions');
const axios = require('axios');
const admin = require('firebase-admin');
admin.initializeApp();
process.env.TZ = 'Asia/Tokyo';

exports.onceYearFunction = onSchedule('00 0 1 1 *', async (event) => {
    //Firestoreから2年前の注文データを取得
    let dt = new Date();
    let searchStart = new Date(dt.getFullYear() - 2, 1, 1, 0, 0, 0);
    let searchEnd = new Date(dt.getFullYear() - 2, 12, 31, 23, 59, 59);
//    let searchStart = new Date(dt.getFullYear(), 1, 1, 0, 0, 0);
//    let searchEnd = new Date(dt.getFullYear(), 12, 31, 23, 59, 59);
    let orderQuerySnapshot = await admin.firestore().collection('order').where('status', '==', 1).where('createdAt', '>=', searchStart).where('createdAt', '<=', searchEnd).get();
    orderQuerySnapshot.forEach((orderDoc) => {
        let orderData = orderDoc.data();
        let carts = JSON.stringify(orderData['carts']);
        let updatedAt = orderData['updatedAt'].toDate();
        let updatedAtString = updatedAt.getFullYear() +
                                '-' +
                                ('0' + (updatedAt.getMonth() + 1)).slice(-2) +
                                '-' +
                                ('0' + updatedAt.getDate()).slice(-2) +
                                ' ' +
                                ('0' + updatedAt.getHours()).slice(-2) +
                                ':' +
                                ('0' + updatedAt.getMinutes()).slice(-2) +
                                ':' +
                                ('0' + updatedAt.getSeconds()).slice(-2);
        let createdAt = orderData['createdAt'].toDate();
        let createdAtString = createdAt.getFullYear() +
                                '-' +
                                ('0' + (createdAt.getMonth() + 1)).slice(-2) +
                                '-' +
                                ('0' + createdAt.getDate()).slice(-2) +
                                ' ' +
                                ('0' + createdAt.getHours()).slice(-2) +
                                ':' +
                                ('0' + createdAt.getMinutes()).slice(-2) +
                                ':' +
                                ('0' + createdAt.getSeconds()).slice(-2);
        let params = new URLSearchParams();
        params.append('id', orderData["id"]);
        params.append('number', orderData["number"]);
        params.append('shopId', orderData["shopId"]);
        params.append('shopNumber', orderData["shopNumber"]);
        params.append('shopName', orderData["shopName"]);
        params.append('shopInvoiceName', orderData["shopInvoiceName"]);
        params.append('carts', carts);
        params.append('status', orderData["status"]);
        params.append('updatedAt', updatedAtString);
        params.append('createdAt', createdAtString);
        axios.post('https://hirome.co.jp/rental/ajax-order.php', params).then(function (response) {
            //console.log(response);
        }).catch(function (error) {
            console.log(error);
        });
        //最後にDocを削除
        orderDoc.ref.delete();
    });
});
