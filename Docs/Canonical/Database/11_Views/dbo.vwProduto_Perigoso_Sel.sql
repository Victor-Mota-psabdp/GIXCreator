SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Produto_Perigoso
CREATE VIEW [dbo].[vwProduto_Perigoso_Sel]
AS
	select 
		PP.cd_prod[Code],
		uncode,classCode,HazMat_Name_Material,HazMat_Description,
		HazMat_Contact,HazMat_Phone,FlashPoint,measureCode,packingCode,ShipperProperName,
		MarinePollutant,MFAG,EMS,Density
	from 
		Produto_Perigoso PP with(nolock)	
		
--select 
--	PP.cd_prod[Code],PC.cd_Proc_Cliente [Product Code],PC.cd_Cliente, 
--	P.apelido [Group],Produto_Descr [Description],
--	NCM_Cliente [N.C.M],uncode,classCode,HazMat_Name_Material,HazMat_Description,
--	HazMat_Contact,HazMat_Phone,FlashPoint,measureCode,packingCode,ShipperProperName,
--	MarinePollutant,MFAG,EMS,Density
--from Produto_Perigoso PP with(nolock)			
--	join Produto_Cliente PC with(nolock) on PC.cd_prod = PP.cd_prod
--	join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente

GO
