SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Retificacao_DI_Rel]--'Grupo ALL','2017-01-01','2019-12-01','2'
(
	
	@Grupo		varchar(50),
	@DtInicial	datetime,
	@DtFinal	datetime,
	@Id_Tp_Proc_Adm		varchar(1)
)
as
 
select 
	R.NUM_PROC							[JOB],
	--R.Id_Tp_Proc_Adm					[ID Admin Process Type],
	TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
	--R.CD_DESPACHANTE					[ID Responsible],
	DESP.Nome_Usuario					[Responsible Name],
	R.NR_RETIFICACAO					[Administrative Process Number],
	CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
	CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
	--R.CD_SOLICITANTE					[ID User],
	SOL.Nome_Usuario					[User Name],
	C.Nome_Raz_Soc						[Client],
	C.Num_CPF_CNPJ						[CNPJ],
	PO.Numero_PO						[PO Nº],
	PO.Numero_DI						[DI Number],
	CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],			
	--R.ID_TP_RET							[ID Type Adjustment],			
	TR.NOME_TP_RET						[Type Adjustment],
	--R.ID_TP_USUARIO_RET					[ID Initiative],
	TU.Nome_TP_Usuario_RET				[Type Initiative],
	R.DE								[From:],
	R.PARA								[To:],
	R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
	R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
	R.NOME_TAX_CLIENTE					[Responsible TAX],	
	NOME_ITO_CLIENTE					[Responsible ITO],
	QTDE_ADICOES_DI						[Total Add to the Declaration],
	QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
	--R.ID_STATUS							[ID Status],
	TS.Status_Descricao					[Type Status],
	CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
	R.Notas								[Notes]
	--,
	--R.ATIVO								[Enabled]			
from [Retificacao_DI] R with(nolock)
	left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
	left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
	left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
	left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
	left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
	left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
	left join Pessoa C on C.Cd_Pes= HOU.cd_cliente
	left join vwPO_Imp PO on PO.Num_Proc = R.Num_Proc
	left join Tipo_Processo_Administrativo TPA on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
	left Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.cd_cliente
	left join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	left join pessoa PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
Where 
	(PG.Apelido = @Grupo or @Grupo ='GRUPO ALL') 	
	and convert(DATE,R.DT_SOLICITACAO,101) between convert(DATE,@DtInicial,101) and convert(DATE,@DtFinal,101)	
	and R.Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm
	
GO
