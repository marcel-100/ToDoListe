const HEADER_LENGTH = 128;
const DATE_LENGTH = 18;
var editId;
var editDate;

/**
 * 
 */
function initXmlRequests() {
  var xmlHttpReq = false;
  var self = this;
  // Mozilla/Safari
  if (window.XMLHttpRequest) {
    self.xmlHttpReq = new XMLHttpRequest();
  }
  // IE
  else if (window.ActiveXObject) {
    self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
  }
  self.xmlHttpReq.open('POST', 'http://' + location.host + '/cgi-bin/todohandler', false);
  self.xmlHttpReq.setRequestHeader('Content-Type',
    'application/x-www-form-urlencoded');
  self.xmlHttpReq.onreadystatechange = function () {
    if (self.xmlHttpReq.readyState == 4) {
      updatepage(self.xmlHttpReq.responseText);
    }
  }
}

/**
 * 
 */
function addZero(i) {
  if (i < 10) {
    i = "0" + i;
  }
  return i;
}
/**
 * 
 */
function getDT(){
  var today = new Date();
  var time = addZero(today.getHours()) + ":" + addZero(today.getMinutes()) + ":" + addZero(today.getSeconds());
  var date = today.getDate() + '.' + (today.getMonth()+1) + '.' + today.getFullYear();
  var dt = time + '_' + date;
  return dt;
}

/**
  * 
  */

function addToTodolist() {

  initXmlRequests();


  var header = document.getElementById('header').value;
  header = header + new Array(HEADER_LENGTH - header.length + 1).join(" ");

  var note = document.getElementById('content').value;

  var dt = getDT();


  if (note === "") {
    alert("Bitte einen Text eingeben.")
  } else {

    qstr = 'content=' + escape(header) + dt + escape(note);  // NOTE: no '?' before querystring
    qstr = qstr + "&action=add\n"

    self.xmlHttpReq.send(qstr);
    document.getElementById('header').value = '';
    document.getElementById('content').value = '';
    showTodoList();
  }

}

function showTodoList() {
  initXmlRequests();
  self.xmlHttpReq.send("action=show\n");
  document.getElementById("header").focus();

}

function clearList() {
  initXmlRequests();
  self.xmlHttpReq.send("action=delete\n");
  showTodoList();
}

function updatepage(str) {

  let items;

  try {
    items = JSON.parse(str).items;
  } catch (error) { }

  if (items instanceof Object) {
    const domNode = document.getElementById("result");

    let i = 0;

    domNode.innerHTML = "";

    items.forEach(function (element) {

      try {
        element = unescape(element);
      } catch (error) { console.error(error); }

      i++;
      console.log('Element: '+ element);
      console.log('ElementLaenge'+ element.length);
      var header = element.substr(0, HEADER_LENGTH);
      var date = element.substr(HEADER_LENGTH, DATE_LENGTH);
      var note = element.substr(DATE_LENGTH+HEADER_LENGTH, element.length);
      console.log('Notiz'+ note);
      console.log('Datum'+ date);

      domNode.innerHTML += '<div class="grid-x grid-margin-x"> <!-- Muss ins JavaScript rein!!! -->' +
        '<div class="cell medium-2 large-1"> ' +
        '<!--<div class="grid-y" style="height: 10%;"></div> -->' +
        '<a class="button small" style="margin: 0 0 0rem 0"  onclick="handleMove(' + i + ", 'up');\">🡹</a> <!--  foundation ln 2456 margin 0 -->" +
        '<a class="button small" style="margin: 0 0 0rem 0" onclick="handleMove(' + i + ", 'down');\">🡻</a>" +
        '</div>' +
        '<div class="cell medium-8 large-10">' +
        '<h2>' + replaceFormatting(escapeHtml(header)) + '</h2>' +
        '<text>' + replaceFormatting(escapeHtml(note)) + '</text></br>' +
        '<text><i>' + replaceFormatting(escapeHtml(date)) + '</i></text>' +
        '</div>' +
        '<div class="cell medium-2 large-1">' +
        '<a class="hollow success button small"  data-open="exampleModal1" style="margin: 0 0 0rem 0"  onclick="editItem2(' + i + ', \'' + escape(header) + '\', \'' + escape(note) + '\');">🖋</a> <!--  foundation ln 2456 margin 0 -->' +


        '<a class="hollow alert button small" style="margin: 0 0 0rem 0" onclick="deleteItem(' + i + ');">⛌</a>' +

        '</div>' +
        '</div> <!-- Ende in JavaScript rein!!! -->'
        ;
    });
  }
}

function deleteItem(id) {
  initXmlRequests();
  self.xmlHttpReq.send("id=" + id + "&action=delete-item\n");
  showTodoList();
}

function handleTextInput(e) {
  if (e.keyCode === 13) {
    addToTodolist();
  }
}

function handleHeaderInput(e) {
  if (e.keyCode === 13) {
    document.getElementById("content").focus();
  }
}

/**
 * 
 * @param {number} id 
 * @param {string} oldValue 
 */

function editItem2(id, header, note,) {
  var item = document.getElementById('newContent');
  console.log("scrapped note:"+note);
  item.value = unescape(note.trim());
  var item2 = document.getElementById('newHeader');
  item2.value = unescape(header).trim();
  editId = id;
}


function editItemSend() {

  var item2 = document.getElementById('newHeader');
  var item1 = document.getElementById('newContent');

  header = item2.value;
  if (header !== null) {
    note = item1.value;


    if (header.length > HEADER_LENGTH) {
      header = header.substr(0, HEADER_LENGTH);
    }


    if (note !== null && note !== "") {

      header = header + new Array(HEADER_LENGTH - header.length + 1).join(" ");
      initXmlRequests();
      self.xmlHttpReq.send('action=edit&id=' + editId + '&content=' + escape(header) + getDT() + escape(note) + '\n');
      showTodoList();
    }
  }
}










function editItem(id, header, note) {
  var noteTrim = note.substr(22,);

  header = prompt("Überschrift", unescape(header).trim());
    if (header !== null) {
      note = prompt("Notiz", unescape(noteTrim).trim())
    

    if (header.length > HEADER_LENGTH) {
      header = header.substr(0, HEADER_LENGTH);
    }


    if (note !== null && note !== "") {

      header = header + new Array(HEADER_LENGTH - header.length + 1).join(" ");

      initXmlRequests();
      self.xmlHttpReq.send('action=edit&id=' + id + '&content=' + escape(header) + getDT() + escape(noteTrim) + '\n');
      showTodoList();
    }
  }
}

/**
 * Ersetze Sonderzeichen mit denen HTML-Code eingefügt werden könnte.
 * Quelle: https://stackoverflow.com/a/6234804
 * 
 * @param {string} unsafe Unsicherer String
 * @returns {string} Sicherer String
 */
function escapeHtml(unsafe) {
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function replaceFormatting(toDoItem) {

  var bold = /\*\*([^\*\*]*\*\*[^\*\*]*)/gm;
  var italic = /__([^__]*__[^__]*)/gm;
  var strikeTrough = /~~([^~~]*~~[^~~]*)/gm;
  var monospace = /```([^```]*```[^```]*)/gm;

  toDoItem = toDoItem.replace(bold, "<b>$1");
  toDoItem = toDoItem.replace(/\*\*/gm, "</b>");

  toDoItem = toDoItem.replace(italic, "<i>$1");
  toDoItem = toDoItem.replace(/__/gm, "</i>");

  toDoItem = toDoItem.replace(strikeTrough, "<del>$1");
  toDoItem = toDoItem.replace(/~~/gm, "</del>");

  toDoItem = toDoItem.replace(monospace, "<span class='mono'>$1");
  toDoItem = toDoItem.replace(/```/gm, "</span>");

  return toDoItem;
}

function handleMove(id, direction) {
  initXmlRequests();
  self.xmlHttpReq.send('action=move&id=' + id + '&direction=' + direction + '\n');
  showTodoList();
}

// Warte mit der Ausführung von JavaScript, bis der Browser das Parsing des DOMs
// abgeschlossen hat.
addEventListener("load", showTodoList);
