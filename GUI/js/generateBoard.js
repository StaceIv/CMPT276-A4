//GLOBAL VARS
var boardJS = new Array();
var item = new Array();
var whiteHandJS = new Array();
var blackHandJS = new Array();
var statusJS; //changed at every function so julia know whats going on.

function generateTable() {
    statusJS = "generateTable"
    //Create a HTML Table element.
    var table = document.createElement('TABLE');
    var tableBlack = document.createElement('TABLE');
    var tableWhite = document.createElement('TABLE');
    //Get the count of columns.
    var columnCount = boardJS[0].length;
    var colBlackCount = blackHandJS.length;
    var colWhiteCount = whiteHandJS.length;
    //Add the data rows.
    for (var i = 0; i < boardJS.length; i++) {
        var row = table.insertRow(-1);
        for (var j = 0; j < columnCount; j++) {
            
            var cell = row.insertCell(-1);
            var pieceDiv = document.createElement('div');

            cell.className = "cell"
            cell.id = boardJS[i][j].color +':' + boardJS[i][j].name + ':' + (j+1) +','+Math.abs(i-boardJS.length);
            pieceDiv.className = boardJS[i][j].color +'Piece';
                        
            if(boardJS[i][j].color =="Black"){
                var shogiDiv = document.createElement('div'); 
                shogiDiv.innerHTML = '☗'
                shogiDiv.className = 'Bshogi'
                pieceDiv.innerHTML = boardJS[i][j].name;
                cell.draggable = true;
                cell.appendChild(shogiDiv);
            }
            else if(boardJS[i][j].color =="White"){
                 var shogiDiv = document.createElement('div');
                 shogiDiv.innerHTML = '☖'
                 shogiDiv.className = 'Wshogi'
                 pieceDiv.innerHTML = boardJS[i][j].name;
                 cell.draggable = true;
                 cell.appendChild(shogiDiv);
            }
            if(boardJS[i][j].name == "k"){
                pieceDiv.id = "King"
            }
            cell.appendChild(pieceDiv);
        }
    }
    //add data to player hands tables
    var rowB = tableBlack.insertRow(-1);
    for (var i = 0; i < blackHandJS.length; i++) {
            var cell = rowB.insertCell(-1);
            var pieceDiv = document.createElement('div');
            cell.className = "cell"
            cell.id = blackHandJS[i].color +':' + blackHandJS[i].name + ':hand';
            pieceDiv.className = blackHandJS[i].color +'Piece';
                        
            if(blackHandJS[i].color =="Black"){
                var shogiDiv = document.createElement('div'); 
                shogiDiv.innerHTML = '☗'
                shogiDiv.className = 'Bshogi'
                pieceDiv.innerHTML = blackHandJS[i].name;
                cell.draggable = true;
                cell.appendChild(shogiDiv);
            }
            else if(blackHandJS[i].color =="White"){
                 var shogiDiv = document.createElement('div');
                 shogiDiv.innerHTML = '☖'
                 shogiDiv.className = 'Wshogi'
                 pieceDiv.innerHTML = blackHandJS[i].name;
                 cell.draggable = true;
                 cell.appendChild(shogiDiv);
            }
            if(blackHandJS[i].name == "k"){
                pieceDiv.id = "King"
            }
            cell.appendChild(pieceDiv);
    }
      //add data to player hands tables
    var rowW = tableWhite.insertRow(-1);
    for (var i = 0; i < whiteHandJS.length; i++) {
            var cell = rowW.insertCell(-1);
            var pieceDiv = document.createElement('div');
            cell.className = "cell"
            cell.id = whiteHandJS[i].color +':' + whiteHandJS[i].name + ':hand' ;
            pieceDiv.className = whiteHandJS[i].color +'Piece';
                        
            if(whiteHandJS[i].color =="Black"){
                var shogiDiv = document.createElement('div'); 
                shogiDiv.innerHTML = '☗'
                shogiDiv.className = 'Bshogi'
                pieceDiv.innerHTML = whiteHandJS[i].name;
                cell.draggable = true;
                cell.appendChild(shogiDiv);
            }
            else if(whiteHandJS[i].color =="White"){
                 var shogiDiv = document.createElement('div');
                 shogiDiv.innerHTML = '☖'
                 shogiDiv.className = 'Wshogi'
                 pieceDiv.innerHTML = whiteHandJS[i].name;
                 cell.draggable = true;
                 cell.appendChild(shogiDiv);
            }
            if(whiteHandJS[i].name == "k"){
                pieceDiv.id = "King"
            }
            cell.appendChild(pieceDiv);
    }  
 
    var dvTable = document.getElementById('dvTable');
    dvTable.innerHTML = '';
    dvTable.appendChild(table);

    var dvBHand = document.getElementById('dvBHand');
    dvBHand.innerHTML = '';
    dvBHand.appendChild(tableBlack);

    var dvWHand = document.getElementById('dvWHand');
    dvWHand.innerHTML = '';
    dvWHand.appendChild(tableWhite);
}
function movejl(){
    statusJS = "movejl";
}

function exit(){
    statusJS = "exit";
}
function resetStatus(){
    statusJS = "";
    return statusJS;
}



/*
//NORMAL CHESS
var init = function() {

var board2 = ChessBoard('board2', {
  draggable: true,
  dropOffBoard: 'trash',
  sparePieces: true
});
$('#startBtn').on('click', board2.start);
$('#clearBtn').on('click', board2.clear);


}; // end init()
$(document).ready(init);
*/

