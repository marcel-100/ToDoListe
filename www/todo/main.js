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
  self.xmlHttpReq.open('POST', 'http://' + window.location.host + '/cgi-bin/todohandler', false);
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
function addToTodolist() {

  initXmlRequests();

  var word = document.getElementById('content').value;

  if (word === "") {
    alert("Bitte einen Text eingeben.")
  } else {

    qstr = 'content=' + escape(word);  // NOTE: no '?' before querystring
    qstr = qstr + "&action=add\n"
    self.xmlHttpReq.send(qstr);
    document.getElementById('content').value = '';
    showTodoList();
  }

}

function showTodoList() {
  initXmlRequests();
  self.xmlHttpReq.send("action=show\n");
}

function clearList() {
  initXmlRequests();
  self.xmlHttpReq.send("action=delete\n");
  showTodoList();
}

function updatepage(str) {

  console.log(str);

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

      domNode.innerHTML += '<li>' +
        '<input type="button" value="✖" onclick="deleteItem(' + i + ');">' +
        '<input type="button" value="✏" onclick="editItem(' + i + ', \'' + window.escape(element) + '\');">' + '<div class="eingabe">' +
        replaceFormatting(escapeHtml(element)) + '</div>' + '</li>';
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

/**
 * 
 * @param {number} id 
 * @param {string} oldValue 
 */
function editItem(id, oldValue) {
  var newValue = window.prompt("", window.unescape(oldValue));
  if (newValue !== null && newValue !== "") {
    initXmlRequests();
    self.xmlHttpReq.send('action=edit&id=' + id + '&content=' + newValue + '\n');
    showTodoList();
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
  

  console.log(toDoItem)

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

  
  console.log(toDoItem)

  return toDoItem;
}


// Warte mit der Ausführung von JavaScript, bis der Browser das Parsing des DOMs
// abgeschlossen hat.
addEventListener("load", showTodoList);
