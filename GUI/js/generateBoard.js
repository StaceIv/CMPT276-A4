//GLOBAL VARS
var boardJS = new Array();
var item = new Array();
var whiteHandJS = new Array();
var blackHandJS = new Array();
var statusJS; //changed at every function so julia know whats going on.
var currentPlayer
var movesArrayJS = new Array();
function getPlayer(player){
    currentPlayer = player
    document.getElementById("currentPlayer").innerHTML = player
}

function generateTable() {
    statusJS = "generateTable";
    //Create a HTML Table element.
    var table = document.createElement('TABLE');
    var tableBlack = document.createElement('TABLE');
    var tableWhite = document.createElement('TABLE');
    table.id = "Board"
    tableBlack.id = "BHand"
    tableWhite.id = "WHand"
    //Get the count of columns.
    var columnCount = boardJS[0].length;
    var colBlackCount = blackHandJS.length;
    var colWhiteCount = whiteHandJS.length;
    //Add the data rows.
    for (var i = 0; i < boardJS.length; i++) {
        var row = table.insertRow(-1);
        for (var j = 0; j < columnCount; j++) {
            
            var cell = row.insertCell(-1);
            var dragDiv = document.createElement('div');
            var pieceDiv = document.createElement('div');

            cell.className = "element"
            cell.id =  (j+1) +','+Math.abs(i-boardJS.length);
            dragDiv.className = "cell"
            dragDiv.id = boardJS[i][j].color +':' + boardJS[i][j].name + ':' + (j+1) +','+Math.abs(i-boardJS.length);
            cell.onclick = function(){ moveFunction(this);};
            pieceDiv.className = boardJS[i][j].color +'Piece';
                        
            if(boardJS[i][j].color =="Black"){
                var shogiDiv = document.createElement('div'); 
                shogiDiv.innerHTML = '☗'
                shogiDiv.className = 'Bshogi'
                pieceDiv.innerHTML = boardJS[i][j].name;
                dragDiv.draggable = true;
                dragDiv.appendChild(shogiDiv);
                dragDiv.appendChild(pieceDiv);
            }
            else if(boardJS[i][j].color =="White"){
                 var shogiDiv = document.createElement('div');
                 shogiDiv.innerHTML = '☖'
                 shogiDiv.className = 'Wshogi'
                 pieceDiv.innerHTML = boardJS[i][j].name;
                 dragDiv.draggable = true;
                 dragDiv.appendChild(shogiDiv);
                 dragDiv.appendChild(pieceDiv);
            }
            else{
                  var shogiDiv = document.createElement('div');
                 shogiDiv.innerHTML = '.'
                 shogiDiv.className = 'emptyPiece'
                 pieceDiv.innerHTML = '.';
                 dragDiv.draggable = false;
                 dragDiv.appendChild(shogiDiv);
                 dragDiv.appendChild(pieceDiv);
            }
            if(boardJS[i][j].name == "k"){
                pieceDiv.id = "King"
            }
            
            cell.appendChild(dragDiv);
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

function deleteTables(){
    console.log("updating")
    document.getElementById("dvBHand").removeChild(document.getElementById("BHand"))
    document.getElementById("dvTable").removeChild(document.getElementById("Board"))
    document.getElementById("dvWHand").removeChild(document.getElementById("WHand"))
     boardJS.splice(0)
     item.splice(0)
     whiteHandJS.splice(0)
     blackHandJS.splice(0)
    
}




function movejl(){
    statusJS = "movejl";
}



//FOR START WINDOW
function startNewGame() {
        statusJS = "newGame"
       
}
function contGame() {
        statusJS = "contGame"
         return document.getElementById("contText").value;
}
function replayGame() {
        statusJS = "replayGame"
         return document.getElementById("replayText").value;
}



//FOR NEW GAME WINDOW

//make stuff visible or not depending on what the new game 

function clearForm(){
    document.getElementById("fileText").value = "";
    document.getElementById("gameType").value ="Shogi";
    document.getElementById("cheatcheckbox").checked = false;
    document.getElementById("timeLimit").value = "";
    document.getElementById("timeInc").value = "";
    document.getElementById("gameDifficulty").value = "Normal";
    document.getElementById("flipcheckbox").checked = false;
}


function remoteGame(){
   clearForm()
    
    
}
function localP(){   
    clearForm()
}

function localAI(){
    clearForm()
}
function HostP(){   
    clearForm()
}
function HostAI(){ 
    clearForm()
}

var filenameJS =""
var gameTypeJS =""
var cheatingJS =""
var timelimitJS=""
var limitaddJS=""
var difficultyJS =""
var flipJS =""

function getValues(){
    filenameJS = document.getElementById("fileText").value;
    gameTypeJS = document.getElementById("gameType").value
    gameTypeJS = gameTypeJS.charAt(0)
    cheatingJS = (document.getElementById("cheatcheckbox").checked == true)? "T": "F";
    timelimitJS = document.getElementById("timeLimit").value
    limitaddJS =  document.getElementById("timeInc").value
    difficultyJS =document.getElementById("gameDifficulty").value 
    flipJS = (document.getElementById("flipcheckbox").checked == true)? "true": "false";
    
    
    statusJS = "continue"
}



//FOR MOVING PIECES

var userMoves = 0 
/*
    0 for source
    1 for 1st destination
    2 for 2nd destination
    3 for 3rd destination
*/


function moveFunction(cell){
    var tempArr = new Array();
    movesArrayJS.push(cell.id)

    

    console.log(movesArrayJS)

}

function makeMove(){
    statusJS = "makeMove"
}






//FOR ALL WINDOWS
function exit(){
    statusJS = "exit";
}
function resetStatus(){
    statusJS = "";
    return statusJS;
}










































