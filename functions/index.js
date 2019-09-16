const functions = require('firebase-functions');
const admin = require('firebase-admin');
const serviceAccount = require('./services-account.json');


admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://baron-260a4.firebaseio.com",
    storageBucket: "baron-260a4.appspot.com",
    projectId: "baron-260a4"
})

const db = admin.firestore()
const message = admin.messaging()
    
const defaultStorage = admin.storage();

exports.onFileUpload = functions.storage.object().onFinalize(async object => {
    const fileName = object.name;
    const bucket = defaultStorage.bucket();
    const file = bucket.file(object.name);
    const results = await file
        .getSignedUrl({
            action: 'read',
            expires: '03-17-2025'
          });
    const url = results[0];
    const category = fileName.split('/')[0];
    let quality = '1';
    
    if (category == 'classic')
        quality = '1'
    else if (category == 'epic')
        quality='2'
    else if (category == 'rare')
        quality='3'
    else if (category == 'legendary')
        quality='4'
    else if (category == 'mythic')
        quality = '5'
    
    admin.firestore().collection('collectibles').add({
            img:url,
            name:fileName.split('/')[1].split('.')[0],
            quality:quality
    }).then((id)=>{console.error(id.id)})
})

exports.onCollectibleAdded = functions.firestore.document('collectibles/{collectible}')
    .onCreate(async snapshot => {
        const collectible = snapshot.data()
        let category = ''
        if (collectible.quality == '1')
            category = 'classic'
        else if (collectible.quality == '2')
            category = 'epic'
        else if (collectible.quality == '3')
            category = 'rare'
        else if (collectible.quality == '4')
            category = 'legendary'
        else if (collectible.quality == '5')
            category = 'mythic'
            
        const payload = {
            notification: {
                title: 'New Collectible Added!',
                body: `${collectible.name} is added in ${category} category`,
                icon: 'https://firebasestorage.googleapis.com/v0/b/baron-260a4.appspot.com/o/icon.png?alt=media&token=6ada6c02-2484-4f3a-a445-0425394c185e',
                clickAction:'FLUTTER_NOTIFICATION_CLICK'
            }
        }
        console.error(`Message sent ${payload.notification}`)
        return message.sendToTopic('collectibles',payload)
    })