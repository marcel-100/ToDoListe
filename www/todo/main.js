const HEADER_LENGTH = 128;
const NOTE_LENGTH = 128;

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
function getDT(){
  var today = new Date();
  var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
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
  note = note + new Array(NOTE_LENGTH - note.length + 1).join(" ");

  var dt = getDT();


  if (note === "") {
    alert("Bitte einen Text eingeben.")
  } else {

    qstr = 'content=' + escape(header) + escape(note) + dt;  // NOTE: no '?' before querystring
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

      var header = element.substr(0, HEADER_LENGTH);
      var note = element.substr(HEADER_LENGTH, element.length);

      domNode.innerHTML += '<li>' +
        '<input type="button" value="✖" onclick="deleteItem(' + i + ');">' +
        
        '<input type="button" value="&#x2B06;" onclick="handleMove(' + i + ", 'up');\"><br/>" +
        '<input type="button" value="✏" onclick="editItem(' + i + ', \'' + escape(header) + '\', \'' + escape(note) + '\');">' +
        '<input type="button" value="&#x2B07;" onclick="handleMove(' + i + ", 'down');\">" +
        '<div class="eingabe">' +
        '<h2>' + replaceFormatting(escapeHtml(header)) + '</h1>' +
        replaceFormatting(escapeHtml(note)) + '</div>' + '</li>';
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

function handleHeaderInput(e){
  if (e.keyCode === 13) {
    document.getElementById("content").focus();
  }
}

/**
 * 
 * @param {number} id 
 * @param {string} oldValue 
 */
function editItem(id, header, note) {

  header = prompt("Überschrift", unescape(header).trim());
    if (header !== null) {
      note = prompt("Notiz", unescape(note).trim())
    

    if (header.length > HEADER_LENGTH) {
      header = header.substr(0, HEADER_LENGTH);
    }

    
    if (note !== null && note !== "") {

      header = header + new Array(HEADER_LENGTH - header.length + 1).join(" ");

      initXmlRequests();
      self.xmlHttpReq.send('action=edit&id=' + id + '&content=' + escape(header) + escape(note) + '\n');
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
