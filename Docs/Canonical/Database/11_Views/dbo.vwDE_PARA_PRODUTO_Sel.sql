SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help DE_PARA_PRODUTO
CREATE VIEW [dbo].[vwDE_PARA_PRODUTO_Sel]
AS
	select 
		GMID [Code],Cd_Cliente, p.Apelido,GMID_Descr_Curta,Trade_Product_Code,Trade_Product_Descr,Plan_Product_Code,
		Plan_Product_Descr,Product_Center_Code,Product_Center_Descr,Performance_Center_Code,Performance_Center_Descr,
		Value_Center_Code,Value_Center_Descr,Business_Code,Business_Descr,Business_Group_Code,
		Business_Group_Descr,P_Descricao,S_Descricao,ITO_Especialista
	from DE_PARA_PRODUTO PC with(nolock)
		join Pessoa P with(nolock) on P.Cd_Pes = PC.cd_Cliente

GO
