SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spINTProdutoPerigoso_Sel]
	(
		@Cd_Produto Varchar(50)
	)
as

select 
	PP.cd_prod,isnull(uncode,'') UNCode,Isnull(classCode,'') classCode,
	Isnull(HazMat_Name_Material,'') HazMat_Name_Material,Isnull(HazMat_Description,'') HazMat_Description,
	Isnull(HazMat_Contact,'') HazMat_Contact,IsNull(HazMat_Phone,'') HazMat_Phone,
	Isnull(FlashPoint,'') FlashPoint,Isnull(measureCode,'') measureCode,Isnull(packingCode,'') packingCode

from dbo.Produto_Perigoso PP with(nolock)
Join Produto_Cliente PC with(nolock) on PC.cd_prod=PP.cd_prod
Where
	cd_proc_cliente=@cd_produto
	and PP.Uncode <> 'NH'


GO
