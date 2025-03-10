const images = ["Assets/ImagePrincipal/Cert01.jpg", "Assets/ImagePrincipal/Cert02.jpg", "Assets/ImagePrincipal/Cert03.jpg", "Assets/ImagePrincipal/Cert04.jpg", "Assets/ImagePrincipal/Cert05.jpg"]; // Substitua pelos seus arquivos reais
let currentIndex = 0;

function updateImage() {
    document.getElementById("cert-image").src = images[currentIndex];
}

function nextImage() {
    currentIndex = (currentIndex + 1) % images.length; // Avança para a próxima imagem
    updateImage();
}

function prevImage() {
    currentIndex = (currentIndex - 1 + images.length) % images.length; // Volta para a imagem anterior
    updateImage();
}