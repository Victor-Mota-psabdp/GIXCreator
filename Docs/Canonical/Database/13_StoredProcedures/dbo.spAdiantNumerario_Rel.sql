SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--21/09/11- para os casos de Exportação trazer o Customer PO, solicitação feita pelo cliente -CADU
--02/12/11 -para os casos de Exportação trazer o Sales Order, solicitação feita pelo cliente -CADU
--[spAdiantNumerario_Rel] 'BOCSR201808063BR'
--      spAPAY_Adiantamento_Sel '2018-07-30','2018-08-02','CSR'
--select * from DE_PARA_PRODUTO
--SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
--where routine_definition like '%Pedido_Det%'
--select * from vwcta where Num_Proc_HIA  ='BOCSR201808064BR'
--select * from Pedido_Ship where Num_Proc = 'IMCSR201808114BR'
--select * from Produto_cliente where cd_prod = '49271'
--select * from De_Para_Produto where GMID = '10078651'

--select * from LLP_BDP_OUT where Num_Proc_LBO  ='BOCSR201808063BR'
--select * from JOB_HBO where Num_Proc_HBO  ='BOCSR201808064BR'
--BOCSR201808063BR
--BOCSR201808064BR

CREATE PROCEDURE [dbo].[spAdiantNumerario_Rel]--'BOCSR201808049BR'

	@Processo varchar(16)

as

if LEFT(@Processo,2) <> 'BO'

	select distinct
		'1058637' Despachante, 
		CNS.Nome_Raz_Soc Cia_Dow,
		--PO.Numero_PO_HIA Ref_Dow,		
		(CASE WHEN HOU.Num_Proc = 'I' THEN 
			--P1.Numero_PO
			isnull([dbo].[fBusca_TipoDocCliente]('N',HOU.Num_Proc,1),'') 
		else
			--P3.Numero_PO
			isnull([dbo].[fBusca_TipoDocCliente]('N',HOU.Num_Proc,3),'') 
		END)  Ref_Dow,
		sum(Vlr_Org_hia) Valor_CC,
		CC.num_proc_hia Referencia_CC,
		' ' Etiqueta,
		' ' Controle, 
		isnull(dbo.fBusca_PRODUTO(HOU.Num_Proc),'') Produto,
		--isnull(DP.GMID_Descr_Curta,Produto_Descr) Produto,
		CX.num_proc_hia Referencia_CX,
		CP190.Campo_Dados [Motivo],
		isnull(Partner.Nome_Raz_Soc,'BDP') [Empresa],		
		'' ACCOUNT,
		--dp.Business_Group_Descr Business_Group,
		isnull([dbo].[fBusca_GMID_Business_Group](HOU.Num_Proc),'') Business_Group,
		--DP.Business_Descr Business_Name	
		isnull([dbo].[fBusca_GMID_Business_Descr](HOU.Num_Proc),'') Business_Name	
	from vwcta_Cte CC With(nolock)
		Left join vwCXAS CX	With(nolock) on CC.num_proc_hia = CX.Num_proc_hia and CC.Cd_tp_tx = CX.Cd_tp_tx and CX.dc_hia = 'C' 
		join vwClienteALLJOBS HOU	With(nolock) on CC.Num_proc_hia = HOU.Num_Proc		
		join pessoa	CNS	With(nolock) on CNS.cd_pes = HOU.cd_cliente
		--Left join vwPO P1 With(nolock) on HOU.num_proc = P1.Num_proc and P1.ID_DC = '1'
		--Left join vwPO P3 With(nolock) on HOU.num_proc = P3.Num_proc and P3.ID_DC = '3'		
		left join Campo_Processo CP190 With(nolock) on HOU.num_proc = CP190.Num_proc and CP190.Id_Campo = '190'	
		left join Campo_Processo CP166 With(nolock) on HOU.num_proc = CP166.Num_proc and CP166.Id_Campo = '166'	
		left join vwPessoa_Partner_Sel Partner	with(nolock) on Partner.cd_pes = CP166.Campo_Dados
		
		--left Join Pedido_Ship		PS		With(nolock) on PS.num_proc=CC.num_proc_HIa
		--left Join Pedido			PD		With(nolock) on PD.cd_pedido=PS.cd_pedido
		----Left Join Pedido_Det		PDET	With(nolock) on PDET.cd_pedido=PS.cd_pedido
		--left join Pedido_Det		PDET	with(nolock) on PDET.Cd_Pedido = PS.Cd_Pedido and PDET.Cd_Produto = PS.Cd_Produto and PDET.item = PS.item
		--left Join Produto_cliente	PC		With(nolock) on PC.cd_prod=ps.cd_produto
		--Left Join De_Para_Produto	DP		With(nolock) on PC.Cd_Proc_Cliente = DP.GMID and DP.cd_cliente=PC.cd_cliente and Business_Code is not null
	where
		CC.num_proc_hia = @Processo  
		and CX.Num_proc_hia is Null 
		and CC.cd_tp_tx like 'XB%' 
		and CC.dc_hia = 'C'
		
	group by
		CNS.Nome_Raz_Soc ,HOU.Num_Proc,
		--P1.Numero_PO
		--,P3.Numero_PO,
		CC.num_proc_hia,
		CX.num_proc_hia,
		CP190.Campo_Dados ,
		Partner.Nome_Raz_Soc
		--DP.GMID_Descr_Curta,Produto_Descr,
		--dp.Business_Group_Descr,
		--DP.Business_Descr	
		
ELSE

	select distinct
		'1058637' Despachante, 
		CNS.Nome_Raz_Soc Cia_Dow,
		--PO.Numero_PO_HIA Ref_Dow,		
		(CASE WHEN HOU.Num_Proc = 'I' THEN 
			--P1.Numero_PO
			isnull([dbo].[fBusca_TipoDocCliente]('N',HOU.Num_Proc,1),'') 
		else
			--P3.Numero_PO
			isnull([dbo].[fBusca_TipoDocCliente]('N',HOU.Num_Proc,3),'') 
		END)  Ref_Dow,
		sum(Vlr_Org_hia) Valor_CC,
		CC.num_proc_hia Referencia_CC,
		' ' Etiqueta,
		' ' Controle, 
		isnull(dbo.fBusca_PRODUTO(HOU.Num_Proc),'') Produto,
		--isnull(DP.GMID_Descr_Curta,Produto_Descr) Produto,
		CX.num_proc_hia Referencia_CX,
		CP190.Campo_Dados [Motivo],
		isnull(Partner.Nome_Raz_Soc,'BDP') [Empresa],		
		'' ACCOUNT,
		--dp.Business_Group_Descr Business_Group,
		isnull([dbo].[fBusca_GMID_Business_Group](HOU.Num_Proc),'') Business_Group,
		--DP.Business_Descr Business_Name	
		isnull([dbo].[fBusca_GMID_Business_Descr](HOU.Num_Proc),'') Business_Name		
	from vwcta_Cte CC With(nolock)
		Left join vwCXAS CX	With(nolock) on CC.num_proc_hia = CX.Num_proc_hia and CC.Cd_tp_tx = CX.Cd_tp_tx and CX.dc_hia = 'C' 
		join vwClienteALLJOBS HOU	With(nolock) on CC.Num_proc_hia = HOU.Num_Proc		
		join pessoa	CNS	With(nolock) on CNS.cd_pes = HOU.cd_cliente
		--Left join vwPO P1 With(nolock) on HOU.num_proc = P1.Num_proc and P1.ID_DC = '1'
		--Left join vwPO P3 With(nolock) on HOU.num_proc = P3.Num_proc and P3.ID_DC = '3'		
		left join Campo_Processo CP190 With(nolock) on HOU.num_proc = CP190.Num_proc and CP190.Id_Campo = '190'	
		left join Campo_Processo CP166 With(nolock) on HOU.num_proc = CP166.Num_proc and CP166.Id_Campo = '166'	
		left join vwPessoa_Partner_Sel Partner	with(nolock) on Partner.cd_pes = CP166.Campo_Dados
		LEFT JOIN JOB_HBO			HBO		With(nolock) on HBO.Num_Proc_HBO = CC.num_proc_HIa
		--left Join Pedido_Ship		PS		With(nolock) on HBO.num_proc=PS.Num_Proc
		--left Join Pedido			PD		With(nolock) on PD.cd_pedido=PS.cd_pedido
		----Left Join Pedido_Det		PDET	With(nolock) on PDET.cd_pedido=PS.cd_pedido
		--left join Pedido_Det		PDET	with(nolock) on PDET.Cd_Pedido = PS.Cd_Pedido and PDET.Cd_Produto = PS.Cd_Produto and PDET.item = PS.item
		--left Join Produto_cliente	PC		With(nolock) on PC.cd_prod=ps.cd_produto
		--Left Join De_Para_Produto	DP		With(nolock) on PC.Cd_Proc_Cliente = DP.GMID and DP.cd_cliente=PC.cd_cliente and Business_Code is not null
	where
		CC.num_proc_hia = @Processo
		and CX.Num_proc_hia is Null 
		and CC.cd_tp_tx like 'XB%' 
		and CC.dc_hia = 'C'
		--and Business_Code is not null
	group by
		CNS.Nome_Raz_Soc ,HOU.Num_Proc,	
		--P1.Numero_PO
		--,P3.Numero_PO,
		CC.num_proc_hia,
		CX.num_proc_hia,
		CP190.Campo_Dados ,
		Partner.Nome_Raz_Soc	
		--DP.GMID_Descr_Curta,Produto_Descr,
		--dp.Business_Group_Descr,
		--DP.Business_Descr	
	
----21/09/11- para os casos de Exportação trazer o Customer PO, solicitação feita pelo cliente -CADU
----02/12/11 -para os casos de Exportação trazer o Sales Order, solicitação feita pelo cliente -CADU

--ALTER	PROCEDURE [dbo].[spAdiantNumerario_Rel] 

--	@Processo varchar(16)

--as

--select '1058637' Despachante, PS.Nome_Raz_Soc Cia_Dow,PO.Numero_PO_HIA Ref_Dow,Vlr_Org_hia Valor_CC,CC.num_proc_hia Referencia_CC,' ' Etiqueta, ' ' Controle, dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)Produto,CX.num_proc_hia Referencia_CX  from cta_cte_hou_imp_aer CC 
--Left join House_imp_aer	HOU	on CC.Num_proc_hia = HOU.Num_Proc_hia
--Left join Pessoa PS on HOU.cd_consig_hia = PS.cd_pes
--Left join PO_hia PO on HOU.num_proc_hia = PO.Num_proc_hia and ID_DC = '1'
--left join caixa_hou_imp_aer CX on CC.num_proc_hia = CX.Num_proc_hia and CC.Cd_tp_tx = CX.Cd_tp_tx and CX.dc_hia = 'C' 
--where CC.num_proc_hia = @Processo and CX.Num_proc_hia is Null and CC.cd_tp_tx like 'XB%' and CC.dc_hia = 'C' 
--Union  
--select '1058637' Despachante, PS.Nome_Raz_Soc Cia_Dow,PO.Numero_PO_HIM Ref_Dow,Vlr_Org_HIM Valor_CC,CC.num_proc_HIM Referencia_CC,' ' Etiqueta, ' ' Controle, dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)Produto,CX.num_proc_HIM Referencia_CX  from cta_cte_hou_imp_MAR CC 
--Left join House_imp_MAR	HOU	on CC.Num_proc_HIM = HOU.Num_Proc_HIM 
--Left join Pessoa PS on HOU.cd_consig_HIM = PS.cd_pes
--Left join PO_HIM PO on HOU.num_proc_HIM = PO.Num_proc_HIM and ID_DC = '1'
--Left join caixa_hou_imp_MAR CX on CC.num_proc_HIM = CX.Num_proc_HIM and CC.Cd_tp_tx = CX.Cd_tp_tx and CX.dc_HIM = 'C' 
--where CC.num_proc_HIM = @Processo and CX.Num_proc_HIM is Null and CC.cd_tp_tx like 'XB%' and CC.dc_HIM = 'C' 
--Union  
--select '1058637' Despachante, PS.Nome_Raz_Soc Cia_Dow,PO.Numero_PO_HIO Ref_Dow,Vlr_Org_HIO Valor_CC,CC.num_proc_HIO Referencia_CC,' ' Etiqueta, ' ' Controle, dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO)Produto,CX.num_proc_HIO Referencia_CX  from cta_cte_hou_imp_OUT CC 
--Left join House_imp_OUT	HOU	on CC.Num_proc_HIO = HOU.Num_Proc_HIO 
--Left join Pessoa PS on HOU.cd_consig_HIO = PS.cd_pes
--Left join PO_HIO PO on HOU.num_proc_HIO = PO.Num_proc_HIO and ID_DC = '1'
--Left join caixa_hou_imp_OUT CX on CC.num_proc_HIO = CX.Num_proc_HIO and CC.Cd_tp_tx = CX.Cd_tp_tx and CX.dc_HIO = 'C' 
--where CC.num_proc_HIO = @Processo and CX.Num_proc_HIO is Null and CC.cd_tp_tx like 'XB%' and CC.dc_HIO = 'C' 
--Union
--select '1058637' Despachante, PS.Nome_Raz_Soc Cia_Dow,PO.Numero_PO_HEA Ref_Dow,Vlr_Org_HEA Valor_CC,CC.num_proc_HEA Referencia_CC,' ' Etiqueta, ' ' Controle, dbo.fBusca_PRODUTO(HOU.Num_Proc_HEA)Produto,CX.num_proc_HEA Referencia_CX  from cta_cte_hou_EXP_AER CC 
--Left join House_EXP_AER	HOU	on CC.Num_proc_HEA = HOU.Num_Proc_HEA 
--Left join Pessoa PS on HOU.cd_export_HEA = PS.cd_pes
--Left join PO_HEA PO on HOU.num_proc_HEA = PO.Num_proc_HEA and ID_DC = '3'
--Left join caixa_hou_EXP_AER CX on CC.num_proc_HEA = CX.Num_proc_HEA and CC.Cd_tp_tx = CX.Cd_tp_tx and CX.dc_HEA = 'C' 
--where CC.num_proc_HEA = @Processo and CX.Num_proc_HEA is Null and CC.cd_tp_tx like 'XB%' and CC.dc_HEA = 'C' 
--Union
--select '1058637' Despachante, PS.Nome_Raz_Soc Cia_Dow,PO.Numero_PO_HEM Ref_Dow,Vlr_Org_HEM Valor_CC,CC.num_proc_HEM Referencia_CC,' ' Etiqueta, ' ' Controle, dbo.fBusca_PRODUTO(HOU.Num_Proc_HEM)Produto,CX.num_proc_HEM Referencia_CX  from cta_cte_hou_EXP_MAR CC 
--Left join House_EXP_MAR	HOU	on CC.Num_proc_HEM = HOU.Num_Proc_HEM 
--Left join Pessoa PS on HOU.cd_export_HEM = PS.cd_pes
--Left join PO_HEM PO on HOU.num_proc_HEM = PO.Num_proc_HEM and ID_DC = '3'
--Left join caixa_hou_EXP_MAR CX on CC.num_proc_HEM = CX.Num_proc_HEM and CC.Cd_tp_tx = CX.Cd_tp_tx and CX.dc_HEM = 'C' 
--where CC.num_proc_HEM = @Processo and CX.Num_proc_HEM is Null and CC.cd_tp_tx like 'XB%' and CC.dc_HEM = 'C' 
--Union
--select '1058637' Despachante, PS.Nome_Raz_Soc Cia_Dow,PO.Numero_PO_HEO Ref_Dow,Vlr_Org_HEO Valor_CC,CC.num_proc_HEO Referencia_CC,' ' Etiqueta, ' ' Controle, dbo.fBusca_PRODUTO(HOU.Num_Proc_HEO)Produto,CX.num_proc_HEO Referencia_CX  from cta_cte_hou_EXP_OUT CC 
--Left join House_EXP_OUT	HOU	on CC.Num_proc_HEO = HOU.Num_Proc_HEO 
--Left join Pessoa PS on HOU.cd_export_HEO = PS.cd_pes
--Left join PO_HEO PO on HOU.num_proc_HEO = PO.Num_proc_HEO and ID_DC = '3'
--Left join caixa_hou_EXP_OUT CX on CC.num_proc_HEO = CX.Num_proc_HEO and CC.Cd_tp_tx = CX.Cd_tp_tx and CX.dc_HEO = 'C' 
--where CC.num_proc_HEO = @Processo and CX.Num_proc_HEO is Null and CC.cd_tp_tx like 'XB%' and CC.dc_HEO = 'C' 
--order by Referencia_CC


GO
