// TypeSafe / Jev client: state in, typed probabilistic decisions out.
// Docs: https://docs.typesafe.ai/

const API_URL = "https://api.typesafe.ai/v1/systemone";
const MODEL = process.env.TYPESAFE_MODEL || "jev-latest";

export function hasApiKey() {
  return Boolean(process.env.TYPESAFE_API_KEY);
}

/**
 * Ask Jev several questions in one parallel call.
 * @param {unknown} state
 * @param {Record<string, object>} questions
 */
export async function systemOne(state, questions) {
  const key = process.env.TYPESAFE_API_KEY;
  if (!key) {
    throw new Error("TYPESAFE_API_KEY is not set");
  }

  const res = await fetch(API_URL, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ model: MODEL, state, questions }),
  });

  const text = await res.text();
  let body;
  try {
    body = JSON.parse(text);
  } catch {
    throw new Error(`Jev returned non-JSON (${res.status}): ${text.slice(0, 200)}`);
  }

  if (!res.ok) {
    throw new Error(`Jev HTTP ${res.status}: ${JSON.stringify(body)}`);
  }
  return body;
}

/** Offline stand-in so demos still run without a key. */
export function mockOracle(state) {
  const vibe = String(state?.player_vibe || "").toLowerCase();
  const dirs = ["north", "south", "east", "west"];
  let move = "west";
  if (/(up|north|sky|moon)/.test(vibe)) move = "north";
  else if (/(down|south|dive|sink)/.test(vibe)) move = "south";
  else if (/(right|east|sunrise)/.test(vibe)) move = "east";
  else if (/(left|west|sunset)/.test(vibe)) move = "west";
  else move = dirs[Math.abs(hash(vibe)) % 4];

  const drama = /epic|doom|opera|scream|destiny/.test(vibe) ? 2.1
    : /quiet|nap|chill|meh/.test(vibe) ? 0.4
    : 1.2;

  const hope = /win|goose|catch|almost|close|victory|theorem/.test(vibe) ? 0.82 : 0.18;

  return {
    model: "mock-oracle",
    answers: {
      paddle: {
        type: "choice",
        choice: move,
        probabilities: Object.fromEntries(dirs.map((d) => [d, d === move ? 0.7 : 0.1])),
        confidence: 0.55,
      },
      goose_smugness: {
        type: "score",
        score: drama > 1.5 ? 2.0 : 1.0,
        legend: {
          "0": "Mildly amused",
          "1": "Visibly smug",
          "2": "Existentially untouchable",
        },
        confidence: 0.6,
      },
      feels_like_winning: {
        type: "noul",
        noul: hope,
      },
      narrator_spice: {
        type: "score",
        score: drama,
        legend: {
          "0": "Dry field notes",
          "1": "Playful banter",
          "2": "Full opera overture",
        },
        confidence: 0.5,
      },
    },
    usage: { input_tokens: 0, output_tokens: 0 },
  };
}

function hash(s) {
  let h = 0;
  for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) | 0;
  return h;
}
