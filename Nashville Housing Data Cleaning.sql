--Standardize SaleDate by remomving the time of day since there are no variation in hours and minutes
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;
UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted
FROM DataCleaningProject.dbo.NashvilleHousing;




--Populating Empty Property Address if ParcelIDs and PropertyAddress are the same but the UniqueID is different
SELECT f.ParcelID, f.PropertyAddress, s.ParcelID, s.PropertyAddress, ISNULL(f.PropertyAddress, s.PropertyAddress)
FROM DataCleaningProject.dbo.NashvilleHousing f
JOIN DataCleaningProject.dbo.NashvilleHousing s
	ON f.ParcelID = s.ParcelID
	AND f.[UniqueID ] <> s.[UniqueID ]
WHERE f.PropertyAddress is null;

Update f
SET PropertyAddress = ISNULL(f.PropertyAddress, s.PropertyAddress)
FROM DataCleaningProject.dbo.NashvilleHousing f
JOIN DataCleaningProject.dbo.NashvilleHousing s
	ON f.ParcelID = s.ParcelID
	AND f.[UniqueID ] <> s.[UniqueID ]
WHERE f.PropertyAddress is null;





--Separating City from Property Address to make two columns instead of one
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM DataCleaningProject.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
Add Property_Address Nvarchar (255);
UPDATE NashvilleHousing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE NashvilleHousing
Add PropertyCity Nvarchar (255);
UPDATE NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));




-- Separating OwnerAddress by address, city, and state for three different columns
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State
FROM DataCleaningProject.dbo.NashvilleHousing;


ALTER TABLE NashvilleHousing
Add Owner_Address Nvarchar (255);
UPDATE NashvilleHousing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar (255);
UPDATE NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar (255);
UPDATE NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);




--Creating two general inputs for SoldAsVacant column instead of multiple inputs that mean the same thing
SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM DataCleaningProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
END
FROM DataCleaningProject.dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
END




--Removing duplicate entries
Select *
FROM DataCleaningProject.dbo.NashvilleHousing;

WITH DupeCTE AS(
Select *,
ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				 UniqueID
				 ) row_num
FROM DataCleaningProject.dbo.NashvilleHousing
)
DELETE
FROM DupeCTE
WHERE row_num > 1;




--Deleting Unused Columns (after supervisor's approval)
ALTER TABLE DataCleaningProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate



SELECT *
FROM DataCleaningProject.dbo.NashvilleHousing