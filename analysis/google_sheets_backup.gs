// Google Sheets backup copy of each participant's summary row (DataPipe/OSF stays the main data store).
//
// Setup (once):
//   1. Create an empty Google Sheet. Extensions > Apps Script. Replace everything there with this file. Save.
//   2. Deploy > New deployment > type "Web app". Execute as: Me. Who has access: Anyone. Deploy, allow access.
//   3. Copy the Web app URL (ends in /exec) into CONFIG.SHEETS_URL in index.html.
// TOKEN must equal CONFIG.SHEETS_TOKEN in index.html. It only keeps out random posts: anyone who reads the
// page source can see it, so check the sheet for odd rows before analysis.
// Every value is stored as plain text so Sheets never turns numbers into dates or changes decimals.
// After editing this script, use Deploy > Manage deployments > Edit > New version (the URL stays the same).

const TOKEN = "ELFrAEXK2k0-uuWG";
const SHEET_NAME = "summary";

function doPost(e) {
  const lock = LockService.getScriptLock();
  lock.waitLock(30000);   // participants finishing at the same moment are written one after another
  try {
    const body = JSON.parse(e.postData.contents);
    if (body.token !== TOKEN) return reply({ok: false, error: "bad token"});
    const row = body.row || {};
    const ss = SpreadsheetApp.getActiveSpreadsheet();
    const sheet = ss.getSheetByName(SHEET_NAME) || ss.insertSheet(SHEET_NAME);

    // Header = column names; new names (e.g. after a study change) are added at the end.
    let header = sheet.getLastColumn() ? sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0].map(String) : [];
    const added = Object.keys(row).filter(k => !header.includes(k));
    if (added.length) {
      header = header.concat(added);
      const h = sheet.getRange(1, 1, 1, header.length);
      h.setNumberFormat("@");
      h.setValues([header]);
      sheet.setFrozenRows(1);
    }

    const values = header.map(k => asText(row[k]));
    const r = sheet.getRange(sheet.getLastRow() + 1, 1, 1, header.length);
    r.setNumberFormat("@");
    r.setValues([values]);
    return reply({ok: true});
  } catch (err) {
    return reply({ok: false, error: String(err)});
  } finally {
    lock.releaseLock();
  }
}

// Plain text; a leading = + @ (or - not followed by a number) would be read as a formula, so it gets an apostrophe.
function asText(v) {
  if (v === undefined || v === null) return "";
  const s = String(v);
  return /^[=+@]/.test(s) || /^-(?![\d.])/.test(s) ? "'" + s : s;
}

function reply(o) {
  return ContentService.createTextOutput(JSON.stringify(o)).setMimeType(ContentService.MimeType.JSON);
}
