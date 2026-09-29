SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vwRegistro_Contabil]
as
select 
	convert(varchar,RF.ID)					[01 ID],
	RF.num_registro							[02 Number], 
	convert(varchar,RF.mes)					[03 Month],
	convert(varchar,RF.ano)					[04 Year], 
	TL.Descricao_tp_Lancamento				[05 Register Type],
	RF.Doc_Number							[06 Doc Number],
	TD.Descricao_Tp_doc						[07 Type Doc],
	RF.num_cnpj								[08 RUT/CNPJ],
	P.Apelido								[09 Company],
	RF.dt_ins								[10 Issue Date],
	RF.dt_venc								[11 Due Date],
	TM.nome_tp_moeda						[12 Currency]
from 
	Registro_financeiro RF	
	join Tipo_Lancamento_RF TL on TL.cd_tipo_lanc = RF.cd_tipo_lanc
	join Tipo_Doc_RF TD on TD.cd_tipo_doc_rf = RF.cd_tp_doc
	join pessoa P on P.cd_pes = RF.cd_pes
	join tipo_moeda TM on TM.cd_Tp_moeda = RF.cd_tp_moeda	
where
	RF.ativo = 1




GO
