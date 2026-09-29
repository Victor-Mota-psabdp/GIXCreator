SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spRetifDI_Rel] 'GRUPO GIVAUDAN','','2014-01-01','2016-10-20'
--100-71215 Douglas, alterei o parametro q estava como DT_RETIFICACAO
CREATE procedure [dbo].[spRetifDI_Rel]
(
	@Grupo		varchar(50),
	@CNPJ		varchar(50),
	@DtInicial	datetime,
	@DtFinal	datetime
)

as

select DISTINCT
	R.NUM_PROC				[JOB],
	C.Nome_Raz_Soc			[Importador],
	C.Num_CPF_CNPJ			[CNPJ],
	CONVERT(varchar(10),R.DT_SOLICITACAO,103)		[Dt.Registro],
	SOL.Nome_Usuario		[Usuario],
	--R.NUM_DI				[DI],
	PO.Numero_PO_HIM		[DI],
	CONVERT(varchar(10),PO.Data_PO_HIM,103)		[DataDI],
	dbo.fBusca_Docs_PO_Modal(R.Num_Proc,1) [PO],
	DESP.Nome_Usuario		[Nome do Despachante],
	R.NR_RETIFICACAO		[Numero do Processo Digital],
	CONVERT(varchar(10),R.DT_RETIFICACAO,103)		[Dt.Protocolo],
	TR.NOME_TP_RET			[Tipo de Retificação],
	TU.Nome_TP_Usuario_RET	[Solicitado por:],
	R.DE					[DE],
	R.PARA					[PARA],
	R.VL_TOTAL_IMPOSTOS		[Vlr Total dos Impostos na DI Original],
	R.VL_TOTAL_IMPOSTOS_RECOLHIDOS [Vlr dos Impostos ou Multas Recolhidos],
	R.NOME_TAX_CLIENTE		[Responsavel no TAX cliente],	
	NOME_ITO_CLIENTE		[Responsavel no ITO cliente],
	QTDE_ADICOES_DI			[Qtde de adições da DI Original],
	QTDE_ADICOES_RETIFICADA	[Qtde de adições Retificadas],
	TS.Status_Descricao		[Status],
	R.ATIVO					[Ativo],
	CONVERT(varchar(10),R.DT_ULTIMA,103)[Dt. Atualização]
from [Retificacao_DI] R with(nolock)
	left join usuario SOL with(nolock)  on SOL.Cd_Usuario = R.CD_SOLICITANTE
	left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
	left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
	left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
	left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
	left join House_Imp_Mar HOU with(nolock) on HOU.Num_Proc_HIM = R.Num_Proc
	left join Pessoa C with(nolock) on C.Cd_Pes= HOU.Cd_Consig_HIM
	left join Po_HIM PO with(nolock) on PO.Num_Proc_HIM = R.Num_Proc and ID_DC = 5
	left Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM 
	left join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	left join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
Where (PG.Apelido = @Grupo or @Grupo ='Grupo ALL') 
	and (REPLACE(REPLACE(right(C.Num_CPF_CNPJ,14),'/',''),'-','') = @CNPJ or @CNPJ='')
	--and DT_RETIFICACAO between  @DtInicial and @DtFinal
	--and date(DT_SOLICITACAO) between  @DtInicial and @DtFinal
	and convert(DATE,DT_SOLICITACAO,101) between convert(DATE,@DtInicial,101) and convert(DATE,@DtFinal,101)
	
	--select 'Current Day' [TD], convert(datetime,convert(varchar(10),getdate(),103),103) 













GO
