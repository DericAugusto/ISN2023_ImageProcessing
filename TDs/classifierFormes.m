function resultats = classifierFormes(img)
    % classifierFormes
    % Classifie les formes dans une image en niveaux de gris en se basant sur leur
    % ellipticité et circularité.
    %
    % Arguments:
    % img (matrix): Image en niveaux de gris à classifier.
    %
    % Retourne:
    % resultats (string array): Tableau de chaînes de caractères contenant les
    %                           classifications des formes détectées dans l'image.
    
    % Binariser l'image en utilisant un seuil automatique
    img_bw = imbinarize(img, graythresh(img));
    
    % Inverser l'image binaire pour que les formes soient en blanc et le fond en noir
    img_bw_inverted = ~img_bw;

    % Utiliser bwlabel sur l'image inversée
    [labeledImage, numberOfBlobs] = bwlabel(img_bw_inverted, 4);

    % Calculer les propriétés géométriques des régions étiquetées
    blobMeasurements = regionprops(labeledImage, 'Area', 'Perimeter', 'MajorAxisLength', 'MinorAxisLength');

    % Analyser chaque région pour identifier la forme
    resultats = strings(1, numberOfBlobs);
    
    for k = 1 : numberOfBlobs
        % Calculer l'ellipticité (rapport entre les axes majeur et mineur)
        ellipticite = blobMeasurements(k).MajorAxisLength / blobMeasurements(k).MinorAxisLength;

        % Calculer la circularité
        circularite = (4 * pi * blobMeasurements(k).Area) / (blobMeasurements(k).Perimeter ^ 2);

        % Identifier la forme
        if circularite > 0.9 && ellipticite < 1.1
            resultats(k) = "Cercle";
        elseif ellipticite < 1.1
            resultats(k) = "Carré";
        elseif ellipticite >= 1.1 && ellipticite < 1.5
            resultats(k) = "Rectangle";
        else
            resultats(k) = "Ellipse";
        end
    end
end
