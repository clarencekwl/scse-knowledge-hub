const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.addNotification = functions.firestore
    .document('questions/{questionId}/replies/{replyId}')
    .onCreate(async (snapshot, context) => {
        const questionId = context.params.questionId;
        const replyId = context.params.replyId;
        const replyData = snapshot.data();

        try {
            // Get the question details
            const questionSnapshot = await admin.firestore().collection('questions').doc(questionId).get();
            const questionData = questionSnapshot.data();

            // Get the FCM token of the question owner
            const questionOwnerSnapshot = await admin.firestore().collection('users').doc(questionData.userId).get();
            const questionOwnerData = questionOwnerSnapshot.data();
            const fcmToken = questionOwnerData.fcmToken;

            // Construct the FCM message
            const message = {
                data: {
                    title: 'New Reply',
                    body: `You received a new reply on your question: ${questionData.title}`,
                    questionId: `${questionId}`
                },
                token: fcmToken,
            };

            // Send the FCM message
            try {
                await admin.messaging().send(message);
            } catch (error) {
                console.error('Error sending FCM message:', error);
            }

            // Add a notification to the "notifications" subcollection of the user
            await admin.firestore().collection('users').doc(questionData.userId).collection('notifications').add({
                'sender_id': replyData.userId,
                'sender_name': replyData.userName,
                'question_id': questionId,
                'question_title': questionData.title,
                'reply_id': replyId,
                'timestamp': admin.firestore.FieldValue.serverTimestamp(),
            });
        } catch (error) {
            console.error('Error processing notification:', error);
        }

        return null;
    });
