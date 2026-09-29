SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spFluxodeCaixa_sel]--'Adiantamentos a Fornecedores'
	@NomeFluxoCaixa	Varchar(50)	
AS

	Declare @cd_FluxodeCaixa Varchar(3)

	Set @cd_FluxodeCaixa  = (Select cd_FluxodeCaixa from FluxodeCaixa where NomeFluxodeCaixa = @NomeFluxoCaixa)

	select  
		CC.cd_cta_ctb cd_cta_ctb, CC.nome_cta_ctb nome_cta_ctb
	from Cta_Ctb CC 
		join FluxodeCaixa FC on FC.cd_FluxodeCaixa = CC.cd_FluxodeCaixa 
	where ck_ativo = 'S' and CC.cd_FluxodeCaixa = @cd_FluxodeCaixa









GO
