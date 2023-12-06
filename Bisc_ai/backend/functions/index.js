/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const express = require("express");
const BodyParser = require("body-parser");
const {celebrate, Joi, errors, Segments} = require("celebrate");

// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
// const {logger} = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");

// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, Timestamp} = require("firebase-admin/firestore");

initializeApp();

const db = getFirestore();
const usersRef = db.collection("users");
const transcriptsRef = db.collection("transcripts");

const USERS_ENDPOINT = "/users";
const TRANSCRIPTS_ENDPOINT = `${USERS_ENDPOINT}/:userId/transcripts`;

const app = express();
app.use(BodyParser.json());

const userValidator = celebrate({
  [Segments.BODY]: Joi.object().keys({
    email: Joi.string().email().required(),
  }),
});

const transcriptValidator = celebrate({
  [Segments.BODY]: Joi.object().keys({
    title: Joi.string().required(),
    text: Joi.string().required(),
  }),
});

// Create/update user
app.put(`${USERS_ENDPOINT}/:id`, userValidator, async (req, res) => {
  const userRef = usersRef.doc(req.params.id);
  const userData = {
    id: req.params.id,
    email: req.body.email,
  };
  await userRef.set(userData);
  res.sendStatus(204);
});

// Get user
app.get(`${USERS_ENDPOINT}/:id`, async (req, res) => {
  const doc = usersRef.doc(req.params.id).get();
  if (!doc.exists) {
    res.sendStatus(404);
  } else {
    res.json(doc.data());
  }
});

// Delete user
app.delete(`${USERS_ENDPOINT}/:id`, async (req, res) => {
  await usersRef.doc(req.params.id).delete();
  res.sendStatus(204);
});

// Upload transcript for user
app.post(TRANSCRIPTS_ENDPOINT, transcriptValidator, async (req, res) => {
  const transcriptData = {
    userId: req.params.userId,
    title: req.body.title,
    dateUploaded: Timestamp.fromDate(new Date()),
    text: req.body.text,
  };
  const writeResult = await transcriptsRef.add(transcriptData);
  res.status(201).json({
    id: writeResult.id,
    ...transcriptData,
  });
});

// Get all transcripts for user
app.get(TRANSCRIPTS_ENDPOINT, async (req, res) => {
  const snapshot = await transcriptsRef.where("userId", "==", req.params.userId)
      .get();
  const data = [];
  snapshot.forEach((doc) => {
    data.push({id: doc.id, ...doc.data()});
  });
  res.json(data);
});

// Get transcript for user
app.get(`${TRANSCRIPTS_ENDPOINT}/:transcriptId`, async (req, res) => {
  const doc = await transcriptsRef.doc(req.params.transcriptId).get();
  if (!doc.exists) {
    res.sendStatus(404);
  } else {
    res.json({id: doc.id, ...doc.data()});
  }
});

// Delete transcript for user
app.delete(`${TRANSCRIPTS_ENDPOINT}/:transcriptId`, async (req, res) => {
  await transcriptsRef.doc(req.params.transcriptId).delete();
  res.sendStatus(204);
});

app.use(errors());

// Expose Express API as a single Cloud Function:
exports.api = onRequest(app);
