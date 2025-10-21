const counter = document.getElementById("counter-number");
async function updateCounter() {
    let response = await fetch("https://2o2bb5tvcmlgmha2tei3jf7hky0hytob.lambda-url.eu-central-1.on.aws/");
    let data = await response.json();
    console.log(data);
    counter.innerText = data;
}

updateCounter();


 
