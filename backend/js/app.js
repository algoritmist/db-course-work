let myId = 0;
let locate;
let lastX=0;
let lastY=0;
function loadReg() {
  const submButton = document.getElementById("submButton");
  submButton.disabled = true;
  const success = (success) => {
    submButton.disabled = false;
    locate = success.coords;
  }
  const err = () => {
    alert("Для регистрации требуется ваша локация");
    location.reload();
  }
  navigator.geolocation.getCurrentPosition(success, err);
}
function registration() {
  const name = document.getElementById("name").value;
  const surName = document.getElementById("surname").value;
  let gender;
  if (document.getElementById("Man").checked) gender = "М";
  if (document.getElementById("Wom").checked) gender = "Ж";
  const birthday = document.getElementById("birthday").value;
  const hellSale = document.getElementById("sale").checked;
  const data = JSON.stringify(
    {
      "first_name": name,
      "last_name": surName,
      "gender": gender,
      "birthday": birthday,
      "hellSale": hellSale,
      "longitude": locate.longitude,
      "latitude": locate.latitude
    });
  const xhr = new XMLHttpRequest()
  xhr.open('POST', 'http://localhost:5050//register_user.php');
  xhr.setRequestHeader("Content-Type", "application/json")
  xhr.send(data)
  xhr.onload = function() {
    myId=xhr.response
    window.location.replace('map.html');
  };


}

function loadMap(){
  const person = document.getElementById("findPerson");
  person.disabled=true;

  const canvas = document.querySelector("canvas");
  const context = canvas.getContext("2d");
  canvas.width=2800;
  canvas.height=1500;
  const img = new Image();
  img.src="img/map.jpeg";
  img.onload = () => {
    context.drawImage(img, 0, 0, canvas.width, canvas.height);
    context.closePath()
  }

  const success =  (success) => {
    context.beginPath();
    lat = success.coords.latitude
    lon = success.coords.longitude
    const x = (lon+180)/360-0.03;
    const y = (1-Math.log2(Math.tan(lat*Math.PI/180)+1/Math.cos(lat*Math.PI/180))/Math.log2(Math.E)/Math.PI)/2;
    context.arc(x*2800, y*1500, 15, 0, 2 * Math.PI, false);
    context.fill();
    context.closePath();
  }
  const err = ()=>{}

  navigator.geolocation.getCurrentPosition(success,err);
}

function changeInput(){
  const person = document.getElementById("findPerson");
  const obj = document.getElementById("findObj");
  obj.disabled=true;
  person.disabled=false ;
  const first = document.getElementById("firstPlace");
  first.style.marginTop="20px";
  const label = document.getElementById("nameLabel");
  label.innerText='Название';
  const second = document.getElementById("secondPlace");
  second.style.display="none";
}

function changeInput2(){
  const person = document.getElementById("findPerson");
  const obj = document.getElementById("findObj");
  obj.disabled=false;
  person.disabled=true ;
  const first = document.getElementById("firstPlace");
  first.style.marginTop="0px";
  const label = document.getElementById("nameLabel");
  label.innerText='Имя';
  const second = document.getElementById("secondPlace");
  second.style.display="block";
}

function findPerson() {
  const name = document.getElementById("name").value;
  const surname = document.getElementById("surName").value;
  const xhr = new XMLHttpRequest()
  const data = JSON.stringify(
    {
      "id": myId,
      "first_name": name,
      "last_name": surname
    });
  drowPoint(Math.random(), Math.random())
  const war = document.getElementById("war");
  war.style.display="block";
  xhr.open('POST', 'http://localhost:5050//find_person.php');
  xhr.setRequestHeader("Content-Type", "application/json")
  xhr.send(data)
  xhr.onload = () =>{
      console.log(xhr.response)
  }
}

function drowPoint(x, y){
  const canvas = document.querySelector("canvas");
  const context = canvas.getContext("2d");
  context.beginPath();
  context.arc(x*2800, y*1500, 15, 0, 2 * Math.PI, false);
  context.fillStyle="black";
  lastX=x;
  lastY=y;
  context.fill();
  context.closePath()
}
function drowWar(){
  const canvas = document.querySelector("canvas");
  const context = canvas.getContext("2d");
  context.beginPath();
  context.arc(lastX*2800, lastY*1500, 15, 0, 2 * Math.PI, false);
  context.fillStyle="red";
  context.fill();
  context.closePath()
}
