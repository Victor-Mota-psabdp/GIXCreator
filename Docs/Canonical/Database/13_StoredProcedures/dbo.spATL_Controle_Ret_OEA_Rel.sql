SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from report where report_name like 'adm%'
--sp_help [Retificacao_DI]
CREATE Procedure [dbo].[spATL_Controle_Ret_OEA_Rel] --spATL_Controle_Ret_OEA_Rel 'GRUPO ALL','',''
(
	@Grupo		varchar(50),
	@DtInicial	datetime,
	@DtFinal	datetime,
	@Id_Tp_Proc_Adm		varchar(1)
)
As

select

	R.NUM_PROC																[REF. DESP.],
	TPA.Nome_Tp_Proc_Adm													[Admin Process Type],
	DESP.Nome_Usuario														[Responsible Name],
	CONVERT(varchar(10),R.DT_RETIFICACAO,103)								[Notification RFB nº],
	CONVERT(varchar(10),R.DT_SOLICITACAO,103)								[Data Solic. Retification],
	DI.Numero_PO															[DI nº],
	CONVERT(varchar(10),DI.Data_PO,103)										[Data DI],
	HIM.Canal																[Channel],
	TP4.Dt_Conclusao														[Customs Clearance Date],
	TP7.Dt_Conclusao														[Transport. Doc Delivery Date],
	HIM.Tp_Carga															[Cargo Type],
	cast(CP.Campo_Dados as Decimal(10,2))									[Quantidade Descarregada],
	HIM.Peso_Liquido														[Netweight KG],    
	HIM.Peso_Bruto															[Gross Weight],
	cast((cast(cp.Campo_Dados as float)/HIM.Peso_Liquido -1) as float)*100	[Differenca %],
	TR.NOME_TP_RET															[Type Adjustment],
	TU.Nome_TP_Usuario_RET													[Type Initiative],
	C.Nome_Raz_Soc															[Client],
	C.Num_CPF_CNPJ															[CNPJ],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')								[PO Nº],
	R.DE																	[From:],
	R.PARA																	[To:],
	R.Notas																	[Retification Description],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10')								[NF Number],
	dbo.fNCM(HOU.Num_Proc)													[NCM], 
	dbo.fBusca_PRODUTO_Produto_Descr(HOU.Num_Proc)							[Product Description],
	R.NOME_TAX_CLIENTE														[Responsible TAX],

	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'Imposto de Importaçao%')		[VALOR II],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'ipi%')							[Valor IPI],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'pis%')							[Valor PIS],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'cofins%')						[Valor COFINS],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'icms%')							[Valor ICMS],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'multa%')						[Valor da Multa],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'Imposto de Importação - CHB 2%')[Valor II],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'juros%')						[Juros - II],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'multa%')						[Multa - II],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'IPI - CHB 2%')					[Valor IPI],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'Juros IPI 1 - CHB%')			[Juros - IPI],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'Multa IPI 1 - CHB%')			[Multa - IPI],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'PIS - CHB%')					[Valor PIS],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'juros%')						[Juros - PIS],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'multa%')						[Multa - PIS],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'Cofins - CHB 2%')				[Valor COFINS],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'juros%')						[Juros - COFINS],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'multa%')						[Multa - COFINS],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'ICMS - CHB 2%')					[Valor ICMS],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'MULTA ICMS 1 - CHB%')			[Valor Multa],
	dbo.fBusca_Custo_Processo(HOU.Num_Proc,'Juros ICMS 1 - CHB%')			[Valor Juros],

	R.VL_TOTAL_IMPOSTOS														[Amount of Original Taxes],
	R.VL_TOTAL_IMPOSTOS_RECOLHIDOS											[Amount of Compl. Taxes After Rectification],
	NOME_ITO_CLIENTE														[Responsible ITO],
	R.QTDE_ADICOES_DI														[Total Add to the Declaration],
	R.QTDE_ADICOES_RETIFICADA												[Amount of rectified add],
	Dst.Nome_Local															[Destination],
	TS.Status_Descricao														[Type Status],
	CONVERT(varchar(10),R.DT_ULTIMA,103)									[Date Update]

from [Retificacao_DI] R with(nolock)
	left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
	left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
	left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
	left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
	left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
	left join vwHouse_Imp HIM with(nolock) on HIM.Num_Proc = R.Num_Proc
	left join Pessoa C on C.Cd_Pes= HOU.cd_cliente
	left join vwPO_ALL DI on DI.Num_Proc = R.Num_Proc and DI.ID_DC = 5

	left join Tipo_Processo_Administrativo TPA on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
	left join Tipo_Carga TC on tc.Cd_Tp_Carga = HIM.Tp_Carga

	left Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.cd_cliente
	left join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	left join pessoa PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
	

	Left Join Campo_Processo CP with(nolock) on hou.num_proc = CP.Num_Proc and CP.Id_Campo=37 and ISNUMERIC(cp.Campo_Dados)=1 

	left Join Localidade Dst with(nolock) on DST.cd_local=cd_dst 
	left Join Pais PDst with(nolock) on PDst.cd_pais=Dst.cd_pais

	Left Outer Join Tarefas_processos	TP4	on R.Num_Proc = TP4.Num_proc and TP4.ID_Task = 4
	Left Outer Join Tarefas_processos	TP7	on R.Num_Proc = TP7.Num_proc and TP7.ID_Task = 7
Where 
	(PG.Apelido = @Grupo or @Grupo ='GRUPO ALL') 	
	and convert(DATE,R.DT_SOLICITACAO,101) between convert(DATE,@DtInicial,101) and convert(DATE,@DtFinal,101)	
	and R.Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm
GO
