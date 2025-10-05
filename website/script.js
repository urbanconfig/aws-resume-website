const counter = document.getElementById("counter-number");
async function updateCounter() {
    let response = await fetch("https://gaqytg2r1f.execute-api.eu-central-1.amazonaws.com");
    let data = await response.json();
    console.log(data);
    counter.innerText = data;
}

updateCounter();


 
