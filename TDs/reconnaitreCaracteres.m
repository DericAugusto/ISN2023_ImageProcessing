function texte = reconnaitreCaracteres(imgPath)
%RECONNAITRECARACTERES Reconnaît et extrait le texte à partir d'une image.
%
% Utilise les traitements d'image pour convertir une image en niveaux de gris,
% ajuster son contraste, et la binariser avant d'appliquer la reconnaissance
% optique de caractères (OCR) pour extraire le texte. La fonction est conçue
% pour traiter les images avec un contraste élevé entre le texte et l'arrière-plan.
%
% Syntaxe:
% texte = reconnaitreCaracteres(imgPath)
%
% Entrée:
% imgPath - Une chaîne de caractères contenant le chemin vers l'image à traiter.
%
% Sortie:
% texte - Une chaîne de caractères contenant le texte reconnu dans l'image.
%
% Exemple:
% texte = reconnaitreCaracteres('chemin/vers/image.png');
% disp(texte);
%
% Note:
% Cette fonction suppose que l'image contient un texte net avec un bon contraste.
% Pour des images avec un faible contraste ou des polices de caractères complexes,
% des ajustements supplémentaires pourraient être nécessaires.
%
% Voir aussi: imread, rgb2gray, imadjust, medfilt2, imresize, imbinarize, ocr.
    
    % Lire l'image à partir du chemin fourni
    img = imread(imgPath);
    
    % Convertir en image en niveaux de gris si elle est en couleur
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    % Ajuster le contraste de l'image pour améliorer la lisibilité
    img = imadjust(img);
    
    % Appliquer un filtrage médian pour réduire le bruit tout en préservant les bords
    img = medfilt2(img, [3 3]);
    
    % Redimensionner l'image pour augmenter la taille du caractère,
    % ce qui peut améliorer la reconnaissance par l'OCR
    img = imresize(img, 5, 'nearest');
    
    % Binariser l'image en utilisant un seuil automatique
    % qui peut aider à séparer le caractère de l'arrière-plan
    img_bw = imbinarize(img);
    
    % Appliquer la reconnaissance optique de caractères (OCR)
    resultatOCR = ocr(img_bw, 'TextLayout', 'Block');
    
    % Extraire le texte reconnu et enlever les espaces blancs superflus
    texte = strtrim(resultatOCR.Text);
end
