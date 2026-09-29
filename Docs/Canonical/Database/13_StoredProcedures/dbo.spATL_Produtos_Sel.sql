SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select top 100 * from mercadoria
--[spATL_Produtos_Sel] 'GRUPO GIVAUDAN'


CREATE procedure [dbo].[spATL_Produtos_Sel]
	@Grupo varchar(50)
as

Declare @Cd_Grupo varchar(30)

set @Cd_Grupo = (select Cd_Pes from Pessoa where Apelido = @Grupo)

set @Cd_Grupo = (select Grupo from Grupo where Cd_Pes_Grupo = @Cd_Grupo)

	SELECT 
	distinct
	MC.CdMercadoria,
	MC.APMercadoria,
	convert(varchar(4000),replace(replace(MC.MMDEscricaoportugues, ' - ',char(10)+CHAR(32)),'  ',char(10)+CHAR(32))) MMDEscricaoportugues,
	--replace(MC.MMDEscricaoportugues,'  ',char(10)+CHAR(32)) MMDEscricaoportugues1
	--MC.MMDEscricaoportugues,
	N.CDNCM
	FROM 
	iglobal.dbo.PROCESSO PR with(nolock)
	join iglobal.dbo.DICAPA DC with(nolock) on DC.IDPROCESSO = PR.IDPROCESSO
	join iglobal.dbo.DIITEM ITEM with(nolock) on ITEM.IDProcesso = DC.IDPROCESSO and ITEM.IDDICAPA = DC.IDDICAPA
	join iglobal.dbo.Mercadoria MC with(nolock) on ITEM.IDMERCADORIA = MC.idMERCADORIA
	left join iglobal.dbo.NCM N with(nolock) on MC.IDNCM = N.IDNCM
	WHERE substring(NRPROCESSO,3,3) = @Cd_Grupo
	
	--('GVA','GVD') --and MC.CdMercadoria = '1472033'
	
	

GO
