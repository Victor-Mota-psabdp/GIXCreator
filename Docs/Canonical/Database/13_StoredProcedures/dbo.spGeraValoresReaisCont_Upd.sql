SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spGeraValoresReaisCont_Upd]
		@Mes	Int,
		@Ano	int

AS



Update Registro_Financeiro  set Valor_Total_Moeda_Local=dbo.FConverterMoedaCont(Cd_TP_Moeda,'REL',@Mes,@Ano)*Total
Where ano=@ano and mes=@mes and cd_tp_moeda not in (select cd_moeda_local from Versao) and ativo=1

Update Registro_Financeiro_Item set Valor_Total_Moeda_Local=dbo.FConverterMoedaCont(Cd_TP_Moeda,'REL',@Mes,@Ano)*RFI.Valor_Total from Registro_Financeiro_Item RFI
Join Registro_Financeiro RF on RF.num_registro=RFI.num_registro and RF.ano=RFI.ano and RFI.mes=RF.mes
Where RF.ano=@ano and RF.mes=@mes and cd_tp_moeda not in (select cd_moeda_local from Versao) and ativo=1



GO
