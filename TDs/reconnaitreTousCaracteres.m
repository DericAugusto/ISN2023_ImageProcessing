function texte = reconnaitreTousCaracteres(imgPath)
%RECONNAITRETOUSCARACTERES Reconnaît et extrait tous les caractères ASCII imprimables d'une image.
%
% Cette fonction prend le chemin d'une image, applique des traitements d'image pour
% la convertir en niveaux de gris, ajuster le contraste et la binariser, avant d'utiliser
% l'OCR pour reconnaître les caractères présents. Elle est configurée pour reconnaître tous
% les caractères ASCII imprimables et renvoie le texte extrait sans espaces superflus.
%
% Syntaxe:
% texte = reconnaitreTousCaracteres(imgPath)
%
% Entrée:
% imgPath - Une chaîne de caractères contenant le chemin vers l'image à traiter.
%
% Sortie:
% texte - Une chaîne de caractères contenant le texte reconnu dans l'image.
%
% Exemple:
% texte = reconnaitreTousCaracteres('chemin/vers/image.png');
% disp(texte);
%
% Note:
% La fonction nécessite que la boîte à outils Computer Vision System Toolbox soit installée.
%
% Voir aussi: imread, rgb2gray, adapthisteq, medfilt2, imresize, imbinarize, ocr.

    % Lire l'image à partir du chemin fourni
    img = imread(imgPath);
    
    % Convertir en image en niveaux de gris si elle est en couleur
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    % Ajuster le contraste de l'image pour améliorer la lisibilité
    img = adapthisteq(img);
    
    % Appliquer un filtrage médian pour réduire le bruit tout en préservant les bords
    img = medfilt2(img, [3 3]);
    
    % Redimensionner l'image pour augmenter la taille du caractère
    img = imresize(img, 2); % Ajuster le facteur si nécessaire
    
    % Binariser l'image
    img_bw = imbinarize(img, 'adaptive', 'Sensitivity', 0.4, 'ForegroundPolarity','dark');
    
    % Appliquer la reconnaissance optique de caractères (OCR)
    % Élargir 'CharacterSet' pour inclure tous les caractères ASCII imprimables
    asciiChars = ['abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', ...
                  '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'];
    resultatOCR = ocr(img_bw, 'TextLayout', 'Block', 'CharacterSet', asciiChars);
    
    % Extraire le texte reconnu et enlever les espaces blancs superflus
    texte = strtrim(resultatOCR.Text);
end
