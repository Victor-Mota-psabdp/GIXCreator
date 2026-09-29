SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_Produtos_Produto_Perigoso_Sel]'Grupo Oxiteno'
CREATE Procedure [dbo].[spATL_Produtos_Produto_Perigoso_Sel]--'Grupo Oxiteno'
(
	@Grupo varchar(20)
)
as

Declare @Cd_Pes varchar(10)
set @Cd_Pes = (select Cd_Pes from Pessoa where Apelido = @Grupo)

select 
	A.Apelido [Group], 
	P.cd_Proc_Cliente [Product Code],
	p.NCM_Cliente [NCM],
	P.Produto_Descr [Description] ,
	(case when c.uncode Is Not null then 'Yes' else 'No' end)[Hazardous],
	c.uncode [UN Code],
	c.classCode [Class Code],
	c.HazMat_Name_Material [Material Name],
	c.FlashPoint [Flashpoint],
	c.measureCode [Temperature],
	c.packingCode [Packing Group],
	c.HazMat_Contact [Contact],
	c.HazMat_Phone [Phone Number]
	
from Produto_Cliente P	
	join pessoa A on p.cd_Cliente = A.Cd_Pes
	left join produto_perigoso C on C.cd_prod = P.cd_prod
WHERE 
	P.cd_Cliente = @Cd_Pes

	

GO
