SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spAX_Debitos2AXDOCSOL_SEL
--when 'IM' then 221
--when 'IA' then 122 
--when 'EA' then 112
--when 'EM' then 216
--when 'EO' then 411
--when 'IO' then 421
--incluido o BO 02/04/2018
CREATE  Procedure [dbo].[spAX_Debitos2AXDOCItemSOL_SEL]-- '8030568', '216'
(
	@ID bigint,
	@Dimensao_2 int
	)
as	

	BEGIN

		--importacao
		Select 
			0,
			I.num_proc Num_Proc,
			Case 
				When SP.Doc_Register ='N' then AXPT.cd_charge_Ax
				else AX.cd_charge_ax
			End	Cd_Tp_TX,
			I.dc DC,
			Vlr_Ref Valor,
			I.Cd_Tp_Moeda Moeda,
			HOU.HAWB Numero_House,
			US.Email CSREmail ,
			US.Nome_Usuario CSRName,
			I.Par_Moeda	 Paridade,
			'Ledger' AccountType,
			hou.MAWB MasterBOLNbr,
			Null MasterBookingNbr,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then 'Exempt'
					When I.DC='C' and SP.Doc_Register ='N'then 'Exempt'
					When I.DC='D' and SP.Doc_Register ='S' then TaxGroup  
					When I.DC='C' and SP.Doc_Register ='S' then TaxGroup  
				End	
			)
			  TaxGroup,
			HOU.Notas Notes,
			(
				Case HOU.Num_Proc
					when  'JOB' then ''
					else HOU.[Master]
				end
			)
			 Num_PRoc_MAster,


			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then AXPT.CC_Custo
					When I.DC='C' and SP.Doc_Register ='N' then AXPT.CC_Receita
					When I.DC='D' and SP.Doc_Register ='S' then AX.CC_Custo
					When I.DC='C' and SP.Doc_Register ='S'  then AX.CC_Receita
				End	
			) Account_Number,
			1 Invoicing,
			(
				Case 
					When SP.cd_servico is not null then SP.cd_servico
					else Null
				End
			) citCityHallServiceCode,
			Case 
				When SP.cd_servico is not null then SP.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
				else Null
			End citCityHallServiceDesc,
			(
				Case 
					When SP.cd_servico is not null then SP.Dt_Ins
					else Null
				End
			) CitTransDateNF,
			(Case 
				When SP.cd_servico is null then ''
				else substring(ref_cnpj,9,4)
			 End
			) [07Invoice],
			(
				Case 
					When SP.cd_servico is not null then Doc_Number
					else Null
				End
			) DocumentNum,		
			I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
		 From  Sol_Pgto_Cta_Cte_Item I with(nolock)
			Join Sol_Pgto_Cta_Cte SP with(nolock) on I.ID=SP.ID
			Join vwHouse_Imp HOU with(nolock) on hou.num_proc=I.num_proc
			--Join House_imp_mar Hou with(nolock) on hou.num_proc_him=I.num_proc
			--Join Job_Imp_Mar Job with(nolock) on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
			Left Join Usuario US with(nolock) on US.Cd_Usuario = HOU.cd_usuario 
			Join Tipo_Taxa TT with(nolock) on  TT.Cd_Tp_Tx = I.Cd_Tp_Tx
			Left Join Tipo_Taxa_AX AX with(nolock) on  AX.Cd_Charge_AX = Cd_Ax_Resultado
			Left Join Tipo_TAxa_AX AXPT with(nolock) on  AXPT.cd_Charge_AX=cd_Ax_Repasse
			Join Pessoa PP with(nolock) on  PP.cd_pes=SP.cd_Cred_dev 
			Left Join Pessoa_ATL_AX AXPP with(nolock) on  (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
			Join dbo.AX_XML_Vendor_Recebido AV with(nolock) on  accountnum=axpp.cd_ax
			--Left Join vwAXDocs IC on (IC.num_proc=I.num_proc and len(numerointernoax)=16 or I.num_proc=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join vwAXDocs IC with(nolock) on IC.num_proc=I.num_proc and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join referencia R with(nolock) on  R.ref_acesso=SP.ref_acesso	
			Left Join Tipo_NF_Doc_Register TNDR with(nolock) on  SP.cd_servico = 	TNDR.cd_servico and SP.Item_lei = TNDR.Item_lei and SP.Ref_Acesso = TNDR.cd_site
		 Where
			I.ID = @ID and IC.cd_tp_tx_Atl is NULL	

union

		--exportacao
		Select 
			0,
			I.num_proc Num_Proc,
			Case 
				When SP.Doc_Register ='N' then AXPT.cd_charge_Ax
				else AX.cd_charge_ax
			End	Cd_Tp_TX,
			I.dc DC,
			Vlr_Ref Valor,
			I.Cd_Tp_Moeda Moeda,
			HOU.HAWB Numero_House,
			US.Email CSREmail ,
			US.Nome_Usuario CSRName,
			I.Par_Moeda	 Paridade,
			'Ledger' AccountType,
			hou.MAWB MasterBOLNbr,
			Null MasterBookingNbr,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then 'Exempt'
					When I.DC='C' and SP.Doc_Register ='N'then 'Exempt'
					When I.DC='D' and SP.Doc_Register ='S' then TaxGroup  
					When I.DC='C' and SP.Doc_Register ='S' then TaxGroup  
				End	
			)
			  TaxGroup,
			HOU.Notas Notes,
			(
				Case HOU.Num_Proc
					when  'JOB' then ''
					else HOU.[Master]
				end
			)
			 Num_PRoc_MAster,


			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then AXPT.CC_Custo
					When I.DC='C' and SP.Doc_Register ='N' then AXPT.CC_Receita
					When I.DC='D' and SP.Doc_Register ='S' then AX.CC_Custo
					When I.DC='C' and SP.Doc_Register ='S'  then AX.CC_Receita
				End	
			) Account_Number,
			1 Invoicing,
			(
				Case 
					When SP.cd_servico is not null then SP.cd_servico
					else Null
				End
			) citCityHallServiceCode,
			Case 
				When SP.cd_servico is not null then SP.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
				else Null
			End citCityHallServiceDesc,
			(
				Case 
					When SP.cd_servico is not null then SP.Dt_Ins
					else Null
				End
			) CitTransDateNF,
			(Case 
				When SP.cd_servico is null then ''
				else substring(ref_cnpj,9,4)
			 End
			) [07Invoice],
			(
				Case 
					When SP.cd_servico is not null then Doc_Number
					else Null
				End
			) DocumentNum,		
			I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
		 From  Sol_Pgto_Cta_Cte_Item I with(nolock)
			Join Sol_Pgto_Cta_Cte SP with(nolock) on I.ID=SP.ID
			Join vwHouse_Exp HOU with(nolock) on hou.num_proc=I.num_proc
			--Join House_imp_mar Hou with(nolock) on hou.num_proc_him=I.num_proc
			--Join Job_Imp_Mar Job with(nolock) on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
			Left Join Usuario US with(nolock) on US.Cd_Usuario = HOU.cd_usuario 
			Join Tipo_Taxa TT with(nolock) on  TT.Cd_Tp_Tx = I.Cd_Tp_Tx
			Left Join Tipo_Taxa_AX AX with(nolock) on  AX.Cd_Charge_AX = Cd_Ax_Resultado
			Left Join Tipo_TAxa_AX AXPT with(nolock) on  AXPT.cd_Charge_AX=cd_Ax_Repasse
			Join Pessoa PP with(nolock) on  PP.cd_pes=SP.cd_Cred_dev 
			Left Join Pessoa_ATL_AX AXPP with(nolock) on  (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
			Join dbo.AX_XML_Vendor_Recebido AV with(nolock) on  accountnum=axpp.cd_ax
			--Left Join vwAXDocs IC on (IC.num_proc=I.num_proc and len(numerointernoax)=16 or I.num_proc=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join vwAXDocs IC with(nolock) on IC.num_proc=I.num_proc and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join referencia R with(nolock) on  R.ref_acesso=SP.ref_acesso	
			Left Join Tipo_NF_Doc_Register TNDR with(nolock) on  SP.cd_servico = 	TNDR.cd_servico and SP.Item_lei = TNDR.Item_lei and SP.Ref_Acesso = TNDR.cd_site
		 Where
			I.ID = @ID and IC.cd_tp_tx_Atl is NULL	
			
		uniON 
	
		Select 
				0,
				I.num_proc Num_Proc,
				Case 
					When SP.Doc_Register ='N' then AXPT.cd_charge_Ax
					else AX.cd_charge_ax
				End	Cd_Tp_TX,
				I.dc DC,
				Vlr_Ref Valor,
				I.Cd_Tp_Moeda Moeda,
				HOU.HAWB Numero_House,
				US.Email CSREmail ,
				US.Nome_Usuario CSRName,
				I.Par_Moeda	 Paridade,
				'Ledger' AccountType,
				HOU.MAWB MasterBOLNbr,
				Null MasterBookingNbr,
				(
					CASE  
							When I.DC='D' and SP.Doc_Register ='N' then 'Exempt'
							When I.DC='C' and SP.Doc_Register ='N'then 'Exempt'
							When I.DC='D' and SP.Doc_Register ='S' then TaxGroup  
							When I.DC='C' and SP.Doc_Register ='S' then TaxGroup  
					End	
				)
				 TaxGroup,
				HOU.OBS Notes,
				(
					Case HOU.Master
						when  'JOB' then ''
						else HOU.Master
					end
				)
				 Num_PRoc_MAster,
				(
					CASE  
							When I.DC='D' and SP.Doc_Register ='N' then AXPT.CC_Custo
							When I.DC='C' and SP.Doc_Register ='N' then AXPT.CC_Receita
							When I.DC='D' and SP.Doc_Register ='S' then AX.CC_Custo
							When I.DC='C' and SP.Doc_Register ='S'  then AX.CC_Receita
					End	
				) Account_Number,
				1 Invoicing,
				(
					Case 
						When SP.cd_servico is not null then SP.cd_servico
						else Null
					End
				) citCityHallServiceCode,
				Case 
					When SP.cd_servico is not null then SP.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
					else Null
				End citCityHallServiceDesc,
				(
					Case 
						When SP.cd_servico is not null then SP.Dt_Ins
						else Null
					End
				) CitTransDateNF,
				
				(Case 
					When SP.cd_servico is null then ''
					else substring(ref_cnpj,9,4)
				 End
				) [07Invoice],
				
				(
					Case 
						When SP.cd_servico is not null then Doc_Number
						else Null
					End
				) DocumentNum,
				I.cd_tp_Tx Codigo_TX_ATL,
				(Case when TT.Tipo_Prod_Code = 1 then '850' else
					(
						Case LEFT(I.Num_Proc,2)			
							when 'BO' then 
								(case LEFT(JBO.Num_Proc,2) 
									when 'IM' then 221
									when 'IA' then 122 
									when 'EA' then 112
									when 'EM' then 216
									when 'EO' then 411
									when 'IO' then 421
									else 800
								End)
						End)
				End)Dimensao_2
			 From  Sol_Pgto_Cta_Cte_Item I
				Join Sol_Pgto_Cta_Cte SP on I.ID=SP.ID
				Join House_BDP_OUT HBO on HBO.num_proc_hbo=I.Num_Proc	
				Join LLP_BDP_OUT LBO on LBO.Num_Proc_lbo=I.Num_Proc
				
				join JOB_HBO JBO on JBO.Num_Proc_HBO = I.Num_Proc
				
				join vwAX_Interface HOU on HOU.Num_Proc = JBO.Num_Proc		
				
				Left Join Usuario US on US.Cd_Usuario = HOU.cd_usuario 
				Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
				Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
				Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
				Join Pessoa PP on PP.cd_pes=SP.cd_Cred_dev
				Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
				Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax 
				Left Join vwAXDocs IC on (IC.num_proc=I.num_proc and len(numerointernoax)=16 or I.num_proc=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
				Left Join referencia R on R.ref_acesso=SP.ref_acesso
				Left Join Tipo_NF_Doc_Register TNDR on SP.cd_servico = 	TNDR.cd_servico and SP.Item_lei = TNDR.Item_lei and SP.Ref_Acesso = TNDR.cd_site	
			 Where
				I.ID = @ID and IC.cd_tp_tx_Atl is NULL	
				and LBO.Id_TP_Servico = 1
	UNION
	
	--bdp others
	--sem job amarrado
	
		Select 
				0,
				I.num_proc Num_Proc,
				Case 
					When SP.Doc_Register ='N' then AXPT.cd_charge_Ax
					else AX.cd_charge_ax
				End	Cd_Tp_TX,
				I.dc DC,
				Vlr_Ref Valor,
				I.Cd_Tp_Moeda Moeda,
				'' Numero_House,
				US.Email CSREmail ,
				US.Nome_Usuario CSRName,
				I.Par_Moeda	 Paridade,
				'Ledger' AccountType,
				null MasterBOLNbr,
				Null MasterBookingNbr,
				(
					CASE  
							When I.DC='D' and SP.Doc_Register ='N' then 'Exempt'
							When I.DC='C' and SP.Doc_Register ='N'then 'Exempt'
							When I.DC='D' and SP.Doc_Register ='S' then TaxGroup  
							When I.DC='C' and SP.Doc_Register ='S' then TaxGroup  
					End	
				)
				 TaxGroup,
				HOU.Descr_Serv_HBO Notes,
				
				'' Num_PRoc_MAster,
				(
					CASE  
							When I.DC='D' and SP.Doc_Register ='N' then AXPT.CC_Custo
							When I.DC='C' and SP.Doc_Register ='N' then AXPT.CC_Receita
							When I.DC='D' and SP.Doc_Register ='S' then AX.CC_Custo
							When I.DC='C' and SP.Doc_Register ='S'  then AX.CC_Receita
					End	
				) Account_Number,
				1 Invoicing,
				(
					Case 
						When SP.cd_servico is not null then SP.cd_servico
						else Null
					End
				) citCityHallServiceCode,
				Case 
					When SP.cd_servico is not null then SP.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
					else Null
				End citCityHallServiceDesc,
				(
					Case 
						When SP.cd_servico is not null then SP.Dt_Ins
						else Null
					End
				) CitTransDateNF,
				
				(Case 
					When SP.cd_servico is null then ''
					else substring(ref_cnpj,9,4)
				 End
				) [07Invoice],
				
				(
					Case 
						When SP.cd_servico is not null then Doc_Number
						else Null
					End
				) DocumentNum,
				I.cd_tp_Tx Codigo_TX_ATL,
				
				(Case when TT.Tipo_Prod_Code = 1 then '850' else
					'800'		
				End)Dimensao_2
				
			 From  Sol_Pgto_Cta_Cte_Item I
				Join Sol_Pgto_Cta_Cte SP on I.ID=SP.ID
				Join House_BDP_OUT Hou on hou.num_proc_hbo=I.num_proc
				Left join JOB_HBO J on J.Num_Proc_HBO = I.num_proc
				Join LLP_BDP_OUT Job on Job.Num_Proc_lbo=I.num_proc
				Left Join Usuario US on US.Cd_Usuario = Job.cd_usuario 
				--Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and I.Cd_Tp_Par = 'OFC' and Dt_Par = Dt_Conv
				Join Tipo_Taxa TT on TT.Cd_Tp_Tx = I.Cd_Tp_Tx
				Left Join Tipo_Taxa_AX AX on AX.Cd_Charge_AX = Cd_Ax_Resultado
				Left Join Tipo_TAxa_AX AXPT on AXPT.cd_Charge_AX=cd_Ax_Repasse
				Join Pessoa PP on PP.cd_pes=SP.cd_Cred_dev
				Left Join Pessoa_ATL_AX AXPP on (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
				Join dbo.AX_XML_Vendor_Recebido AV on accountnum=axpp.cd_ax 
				Left Join vwAXDocs IC on (IC.num_proc=I.num_proc and len(numerointernoax)=16 or I.num_proc=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
				Left Join referencia R on R.ref_acesso=SP.ref_acesso
				Left Join Tipo_NF_Doc_Register TNDR on SP.cd_servico = 	TNDR.cd_servico and SP.Item_lei = TNDR.Item_lei and SP.Ref_Acesso = TNDR.cd_site	
			 Where
				I.ID = @ID and IC.cd_tp_tx_Atl is NULL	
				and J.Num_Proc is null
				and Job.Id_TP_Servico > 1	
END
/*

--Importação Maritima
if @Dimensao_2 = 221
	BEGIN
		Select 
			0,
			I.num_proc Num_Proc,
			Case 
				When SP.Doc_Register ='N' then AXPT.cd_charge_Ax
				else AX.cd_charge_ax
			End	Cd_Tp_TX,
			I.dc DC,
			Vlr_Ref Valor,
			I.Cd_Tp_Moeda Moeda,
			HAWB_HIM Numero_House,
			US.Email CSREmail ,
			US.Nome_Usuario CSRName,
			I.Par_Moeda	 Paridade,
			'Ledger' AccountType,
			hou.MAWB_HIM MasterBOLNbr,
			Null MasterBookingNbr,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then 'Exempt'
					When I.DC='C' and SP.Doc_Register ='N'then 'Exempt'
					When I.DC='D' and SP.Doc_Register ='S' then TaxGroup  
					When I.DC='C' and SP.Doc_Register ='S' then TaxGroup  
				End	
			)
			  TaxGroup,
			Obs_HIM Notes,
			(
				Case Num_Proc_MIM
					when  'JOB' then ''
					else num_proc_mim
				end
			)
			 Num_PRoc_MAster,


			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then AXPT.CC_Custo
					When I.DC='C' and SP.Doc_Register ='N' then AXPT.CC_Receita
					When I.DC='D' and SP.Doc_Register ='S' then AX.CC_Custo
					When I.DC='C' and SP.Doc_Register ='S'  then AX.CC_Receita
				End	
			) Account_Number,
			1 Invoicing,
			(
				Case 
					When SP.cd_servico is not null then SP.cd_servico
					else Null
				End
			) citCityHallServiceCode,
			Case 
				When SP.cd_servico is not null then SP.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
				else Null
			End citCityHallServiceDesc,
			(
				Case 
					When SP.cd_servico is not null then SP.Dt_Ins
					else Null
				End
			) CitTransDateNF,
			(Case 
				When SP.cd_servico is null then ''
				else substring(ref_cnpj,9,4)
			 End
			) [07Invoice],
			(
				Case 
					When SP.cd_servico is not null then Doc_Number
					else Null
				End
			) DocumentNum,		
			I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
		 From  Sol_Pgto_Cta_Cte_Item I with(nolock)
			Join Sol_Pgto_Cta_Cte SP with(nolock) on I.ID=SP.ID
			Join House_imp_mar Hou with(nolock) on hou.num_proc_him=I.num_proc
			Join Job_Imp_Mar Job with(nolock) on Job.Num_Proc_HIM=Hou.Num_Proc_HIM 
			Left Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario 
			Join Tipo_Taxa TT with(nolock) on  TT.Cd_Tp_Tx = I.Cd_Tp_Tx
			Left Join Tipo_Taxa_AX AX with(nolock) on  AX.Cd_Charge_AX = Cd_Ax_Resultado
			Left Join Tipo_TAxa_AX AXPT with(nolock) on  AXPT.cd_Charge_AX=cd_Ax_Repasse
			Join Pessoa PP with(nolock) on  PP.cd_pes=SP.cd_Cred_dev 
			Left Join Pessoa_ATL_AX AXPP with(nolock) on  (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
			Join dbo.AX_XML_Vendor_Recebido AV with(nolock) on  accountnum=axpp.cd_ax
			--Left Join vwAXDocs IC on (IC.num_proc=I.num_proc and len(numerointernoax)=16 or I.num_proc=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join vwAXDocs IC with(nolock) on IC.num_proc=I.num_proc and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join referencia R with(nolock) on  R.ref_acesso=SP.ref_acesso	
			Left Join Tipo_NF_Doc_Register TNDR with(nolock) on  SP.cd_servico = 	TNDR.cd_servico and SP.Item_lei = TNDR.Item_lei and SP.Ref_Acesso = TNDR.cd_site
		 Where
			I.ID = @ID and IC.cd_tp_tx_Atl is NULL		
	END

--Importação Aerea
else if @Dimensao_2 = 122
	BEGIN
		Select 
			0,
			I.num_proc Num_Proc,
			Case 
				When SP.Doc_Register ='N' then AXPT.cd_charge_Ax
				else AX.cd_charge_ax
			End	Cd_Tp_TX,
			I.dc DC,
			Vlr_Ref Valor,
			I.Cd_Tp_Moeda Moeda,
			HAWB_hia Numero_House,
			US.Email CSREmail ,
			US.Nome_Usuario CSRName,
			I.Par_Moeda	 Paridade,
			'Ledger' AccountType,
			hou.MAWB_hia MasterBOLNbr,
			Null MasterBookingNbr,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then 'Exempt'
					When I.DC='C' and SP.Doc_Register ='N'then 'Exempt'
					When I.DC='D' and SP.Doc_Register ='S' then TaxGroup  
					When I.DC='C' and SP.Doc_Register ='S' then TaxGroup  
				End	
			)
			  TaxGroup,
			Obs_hia Notes,
			(
				Case Num_Proc_MIA
					when  'JOB' then ''
					else num_proc_MIA
				end
			)
			 Num_PRoc_MAster,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then AXPT.CC_Custo
					When I.DC='C' and SP.Doc_Register ='N' then AXPT.CC_Receita
					When I.DC='D' and SP.Doc_Register ='S' then AX.CC_Custo
					When I.DC='C' and SP.Doc_Register ='S'  then AX.CC_Receita
				End	
			) Account_Number,
			1 Invoicing,
			(
				Case 
					When SP.cd_servico is not null then SP.cd_servico
					else Null
				End
			) citCityHallServiceCode,
			Case 
				When SP.cd_servico is not null then SP.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
				else Null
			End citCityHallServiceDesc,
			(
				Case 
					When SP.cd_servico is not null then SP.Dt_Ins
					else Null
				End
			) CitTransDateNF,
			(Case 
				When SP.cd_servico is null then ''
				else substring(ref_cnpj,9,4)
			 End
			) [07Invoice],
			(
				Case 
					When SP.cd_servico is not null then Doc_Number
					else Null
				End
			) DocumentNum,			
			I.cd_tp_Tx Codigo_TX_ATL,
			(Case when TT.Tipo_Prod_Code = 1 then '850' else
			(
			Case LEFT(I.num_proc,2) 
			
				when 'IM' then 221
				when 'IA' then 122 
				when 'EA' then 112
				when 'EM' then 216
				when 'EO' then 411
				when 'IO' then 421
			End
			)End)Dimensao_2
		 From  Sol_Pgto_Cta_Cte_Item I with(nolock)
			Join Sol_Pgto_Cta_Cte SP with(nolock) on  I.ID=SP.ID
			Join House_imp_Aer Hou with(nolock) on hou.num_proc_hia=I.num_proc
			Join Job_Imp_Aer Job with(nolock) on Job.Num_Proc_hia=Hou.Num_Proc_hia 
			Left Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario 
			Join Tipo_Taxa TT with(nolock) on  TT.Cd_Tp_Tx = I.Cd_Tp_Tx
			Left Join Tipo_Taxa_AX AX with(nolock) on  AX.Cd_Charge_AX = Cd_Ax_Resultado
			Left Join Tipo_TAxa_AX AXPT with(nolock) on  AXPT.cd_Charge_AX=cd_Ax_Repasse
			Join Pessoa PP with(nolock) on  PP.cd_pes=SP.cd_Cred_dev 
			Left Join Pessoa_ATL_AX AXPP with(nolock) on  (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
			Join dbo.AX_XML_Vendor_Recebido AV with(nolock) on  accountnum=axpp.cd_ax
			--Left Join vwAXDocs IC on (IC.num_proc=I.num_proc and len(numerointernoax)=16 or I.num_proc=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join vwAXDocs IC with(nolock) on  IC.num_proc=I.num_proc and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join referencia R with(nolock) on  R.ref_acesso=SP.ref_acesso	
			Left Join Tipo_NF_Doc_Register TNDR with(nolock) on  SP.cd_servico = 	TNDR.cd_servico and SP.Item_lei = TNDR.Item_lei and SP.Ref_Acesso = TNDR.cd_site
		 Where
			I.ID = @ID and IC.cd_tp_tx_Atl is NULL
	END
	
--Exportação Maritima
else if @Dimensao_2 = 216
	BEGIN
		Select 
			0,
			I.num_proc Num_Proc,
			Case 
				When SP.Doc_Register ='N' then AXPT.cd_charge_Ax
				else AX.cd_charge_ax
			End	Cd_Tp_TX,
			I.dc DC,
			Vlr_Ref Valor,
			I.Cd_Tp_Moeda Moeda,
			HAWB_hem Numero_House,
			US.Email CSREmail ,
			US.Nome_Usuario CSRName,
			I.Par_Moeda	 Paridade,
			'Ledger' AccountType,
			hou.MAWB_hem MasterBOLNbr,
			Null MasterBookingNbr,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then 'Exempt'
					When I.DC='C' and SP.Doc_Register ='N'then 'Exempt'
					When I.DC='D' and SP.Doc_Register ='S' then TaxGroup  
					When I.DC='C' and SP.Doc_Register ='S' then TaxGroup  
				End	
			)
			  TaxGroup,
			Obs_hem Notes,
			(
				Case Num_Proc_mem
					when  'JOB' then ''
					else num_proc_mem
				end
			)
			 Num_PRoc_MAster,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then AXPT.CC_Custo
					When I.DC='C' and SP.Doc_Register ='N' then AXPT.CC_Receita
					When I.DC='D' and SP.Doc_Register ='S' then AX.CC_Custo
					When I.DC='C' and SP.Doc_Register ='S'  then AX.CC_Receita
				End	
			) Account_Number,
			1 Invoicing,
			(
				Case 
					When SP.cd_servico is not null then SP.cd_servico
					else Null
				End
			) citCityHallServiceCode,
			Case 
				When SP.cd_servico is not null then SP.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
				else Null
			End citCityHallServiceDesc,
			(
				Case 
					When SP.cd_servico is not null then SP.Dt_Ins
					else Null
				End
			) CitTransDateNF,
			(Case 
				When SP.cd_servico is null then ''
				else substring(ref_cnpj,9,4)
			 End
			) [07Invoice],
			(
				Case 
					When SP.cd_servico is not null then Doc_Number
					else Null
				End
			) DocumentNum,
			I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
		 From  Sol_Pgto_Cta_Cte_Item I with(nolock)
			Join Sol_Pgto_Cta_Cte SP with(nolock) on  I.ID=SP.ID
			Join House_exp_MAR Hou with(nolock) on hou.num_proc_hem=I.num_proc
			Join Job_exp_MAR Job with(nolock) on Job.Num_Proc_hem=Hou.Num_Proc_hem 
			Left Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario 
			--Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and I.Cd_Tp_Par = 'OFC' and Dt_Par = Dt_Conv
			Join Tipo_Taxa TT with(nolock) on  TT.Cd_Tp_Tx = I.Cd_Tp_Tx
			Left Join Tipo_Taxa_AX AX with(nolock) on  AX.Cd_Charge_AX = Cd_Ax_Resultado
			Left Join Tipo_TAxa_AX AXPT with(nolock) on  AXPT.cd_Charge_AX=cd_Ax_Repasse
			Join Pessoa PP with(nolock) on  PP.cd_pes=SP.cd_Cred_dev 
			Left Join Pessoa_ATL_AX AXPP with(nolock) on  (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
			Join dbo.AX_XML_Vendor_Recebido AV with(nolock) on  accountnum=axpp.cd_ax
			--Left Join vwAXDocs IC on (IC.num_proc=I.num_proc and len(numerointernoax)=16 or I.num_proc=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join vwAXDocs IC with(nolock) on IC.num_proc=I.num_proc and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join referencia R with(nolock) on  R.ref_acesso=SP.ref_acesso
			Left Join Tipo_NF_Doc_Register TNDR with(nolock) on  SP.cd_servico = 	TNDR.cd_servico and SP.Item_lei = TNDR.Item_lei and SP.Ref_Acesso = TNDR.cd_site	
		 Where
			I.ID = @ID and IC.cd_tp_tx_Atl is null
		END

--Exportação Aerea
else if @Dimensao_2 = 112
	BEGIN
		Select 
			0,
			I.num_proc Num_Proc,
			Case 
				When SP.Doc_Register ='N' then AXPT.cd_charge_Ax
				else AX.cd_charge_ax
			End	Cd_Tp_TX,
			I.dc DC,
			Vlr_Ref Valor,
			I.Cd_Tp_Moeda Moeda,
			HAWB_hea Numero_House,
			US.Email CSREmail ,
			US.Nome_Usuario CSRName,
			I.Par_Moeda	 Paridade,
			'Ledger' AccountType,
			hou.MAWB_hea MasterBOLNbr,
			Null MasterBookingNbr,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then 'Exempt'
					When I.DC='C' and SP.Doc_Register ='N'then 'Exempt'
					When I.DC='D' and SP.Doc_Register ='S' then TaxGroup  
					When I.DC='C' and SP.Doc_Register ='S' then TaxGroup  
				End	
			)
			  TaxGroup,
			Obs_hea Notes,
			(
				Case Num_Proc_MEA
					when  'JOB' then ''
					else num_proc_MEA
				end
			)
			 Num_PRoc_MAster,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then AXPT.CC_Custo
					When I.DC='C' and SP.Doc_Register ='N' then AXPT.CC_Receita
					When I.DC='D' and SP.Doc_Register ='S' then AX.CC_Custo
					When I.DC='C' and SP.Doc_Register ='S'  then AX.CC_Receita
				End	
			) Account_Number,
			1 Invoicing,
			(
				Case 
					When SP.cd_servico is not null then SP.cd_servico
					else Null
				End
			) citCityHallServiceCode,
			Case 
				When SP.cd_servico is not null then SP.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
				else Null
			End citCityHallServiceDesc,
			(
				Case 
					When SP.cd_servico is not null then SP.Dt_Ins
					else Null
				End
			) CitTransDateNF,
			(Case 
				When SP.cd_servico is null then ''
				else substring(ref_cnpj,9,4)
			 End
			) [07Invoice],
			(
				Case 
					When SP.cd_servico is not null then Doc_Number
					else Null
				End
			) DocumentNum,
			I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
		 From  Sol_Pgto_Cta_Cte_Item I with(nolock)
			Join Sol_Pgto_Cta_Cte SP with(nolock) on  I.ID=SP.ID
			Join House_exp_aer Hou with(nolock) on hou.num_proc_hea=I.num_proc
			Join Job_exp_aer Job with(nolock) on Job.Num_Proc_hea=Hou.Num_Proc_hea 
			Left Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario 
			--Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and I.Cd_Tp_Par = 'OFC' and Dt_Par = Dt_Conv
			Join Tipo_Taxa TT with(nolock) on  TT.Cd_Tp_Tx = I.Cd_Tp_Tx
			Left Join Tipo_Taxa_AX AX with(nolock) on  AX.Cd_Charge_AX = Cd_Ax_Resultado
			Left Join Tipo_TAxa_AX AXPT with(nolock) on  AXPT.cd_Charge_AX=cd_Ax_Repasse
			Join Pessoa PP with(nolock) on  PP.cd_pes=SP.cd_Cred_dev 
			Left Join Pessoa_ATL_AX AXPP with(nolock) on  (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
			Join dbo.AX_XML_Vendor_Recebido AV with(nolock) on  accountnum=axpp.cd_ax
			--Left Join vwAXDocs IC on (IC.num_proc=I.num_proc and len(numerointernoax)=16 or I.num_proc=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join vwAXDocs IC with(nolock) on IC.num_proc=I.num_proc and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join referencia R with(nolock) on  R.ref_acesso=SP.ref_acesso
			Left Join Tipo_NF_Doc_Register TNDR with(nolock) on  SP.cd_servico = 	TNDR.cd_servico and SP.Item_lei = TNDR.Item_lei and SP.Ref_Acesso = TNDR.cd_site	
		 Where
			I.ID = @ID and IC.cd_tp_tx_Atl is null
	END
	
--Exportação Outros
else if @Dimensao_2 = 411
	BEGIN
		Select 
			0,
			I.num_proc Num_Proc,
			Case 
				When SP.Doc_Register ='N' then AXPT.cd_charge_Ax
				else AX.cd_charge_ax
			End	Cd_Tp_TX,
			I.dc DC,
			Vlr_Ref Valor,
			I.Cd_Tp_Moeda Moeda,
			HAWB_heo Numero_House,
			US.Email CSREmail ,
			US.Nome_Usuario CSRName,
			I.Par_Moeda	 Paridade,
			'Ledger' AccountType,
			hou.MAWB_heo MasterBOLNbr,
			Null MasterBookingNbr,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then 'Exempt'
					When I.DC='C' and SP.Doc_Register ='N'then 'Exempt'
					When I.DC='D' and SP.Doc_Register ='S' then TaxGroup  
					When I.DC='C' and SP.Doc_Register ='S' then TaxGroup  
				End	
			)
			  TaxGroup,
			Obs_heo Notes,
			(
				Case Num_Proc_master
					when  'JOB' then ''
					else num_proc_master
				end
			)
			 Num_PRoc_MAster,
			(
				CASE  
					When I.DC='D' and SP.Doc_Register ='N' then AXPT.CC_Custo
					When I.DC='C' and SP.Doc_Register ='N' then AXPT.CC_Receita
					When I.DC='D' and SP.Doc_Register ='S' then AX.CC_Custo
					When I.DC='C' and SP.Doc_Register ='S'  then AX.CC_Receita
				End	
			) Account_Number,
			1 Invoicing,
			(
				Case 
					When SP.cd_servico is not null then SP.cd_servico
					else Null
				End
			) citCityHallServiceCode,
			Case 
				When SP.cd_servico is not null then SP.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
				else Null
			End citCityHallServiceDesc,
			(
				Case 
					When SP.cd_servico is not null then SP.Dt_Ins
					else Null
				End
			) CitTransDateNF,
			(Case 
				When SP.cd_servico is null then ''
				else substring(ref_cnpj,9,4)
			 End
			) [07Invoice],
			(
				Case 
					When SP.cd_servico is not null then Doc_Number
					else Null
				End
			) DocumentNum,
			I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
		 From  Sol_Pgto_Cta_Cte_Item I with(nolock)
			Join Sol_Pgto_Cta_Cte SP with(nolock) on  I.ID=SP.ID
			Join House_exp_OUT Hou with(nolock) on hou.num_proc_heo=I.num_proc
			Join LLP_exp_OUT Job with(nolock) on Job.Num_Proc_Leo=Hou.Num_Proc_heo 
			Left Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario 
			--Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and I.Cd_Tp_Par = 'OFC' and Dt_Par = Dt_Conv
			Join Tipo_Taxa TT with(nolock) on  TT.Cd_Tp_Tx = I.Cd_Tp_Tx
			Left Join Tipo_Taxa_AX AX with(nolock) on  AX.Cd_Charge_AX = Cd_Ax_Resultado
			Left Join Tipo_TAxa_AX AXPT with(nolock) on  AXPT.cd_Charge_AX=cd_Ax_Repasse
			Join Pessoa PP with(nolock) on  PP.cd_pes=SP.cd_Cred_dev
			Left Join Pessoa_ATL_AX AXPP with(nolock) on  (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
			Join dbo.AX_XML_Vendor_Recebido AV with(nolock) on  accountnum=axpp.cd_ax 
			--Left Join vwAXDocs IC on (IC.num_proc=I.num_proc and len(numerointernoax)=16 or I.num_proc=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join vwAXDocs IC with(nolock) on IC.num_proc=I.num_proc and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
			Left Join referencia R with(nolock) on  R.ref_acesso=SP.ref_acesso
			Left Join Tipo_NF_Doc_Register TNDR with(nolock) on  SP.cd_servico = 	TNDR.cd_servico and SP.Item_lei = TNDR.Item_lei and SP.Ref_Acesso = TNDR.cd_site	
		 Where
			I.ID = @ID and IC.cd_tp_tx_Atl is NULL
	END


--Importação Outros
else if @Dimensao_2 = 421
		BEGIN
			Select 
				0,
				I.num_proc Num_Proc,
				Case 
					When SP.Doc_Register ='N' then AXPT.cd_charge_Ax
					else AX.cd_charge_ax
				End	Cd_Tp_TX,
				I.dc DC,
				Vlr_Ref Valor,
				I.Cd_Tp_Moeda Moeda,
				HAWB_hio Numero_House,
				US.Email CSREmail ,
				US.Nome_Usuario CSRName,
				I.Par_Moeda	 Paridade,
				'Ledger' AccountType,
				hou.MAWB_hio MasterBOLNbr,
				Null MasterBookingNbr,
				(
					CASE  
							When I.DC='D' and SP.Doc_Register ='N' then 'Exempt'
							When I.DC='C' and SP.Doc_Register ='N'then 'Exempt'
							When I.DC='D' and SP.Doc_Register ='S' then TaxGroup  
							When I.DC='C' and SP.Doc_Register ='S' then TaxGroup  
					End	
				)
				 TaxGroup,
				Obs_hio Notes,
				(
					Case Num_Proc_master
						when  'JOB' then ''
						else num_proc_master
					end
				)
				 Num_PRoc_MAster,
				(
					CASE  
							When I.DC='D' and SP.Doc_Register ='N' then AXPT.CC_Custo
							When I.DC='C' and SP.Doc_Register ='N' then AXPT.CC_Receita
							When I.DC='D' and SP.Doc_Register ='S' then AX.CC_Custo
							When I.DC='C' and SP.Doc_Register ='S'  then AX.CC_Receita
					End	
				) Account_Number,
				1 Invoicing,
				(
					Case 
						When SP.cd_servico is not null then SP.cd_servico
						else Null
					End
				) citCityHallServiceCode,
				Case 
					When SP.cd_servico is not null then SP.Item_lei + ' - ' + dbo.FRemoveAcentuacao(TNDR.Descricao)
					else Null
				End citCityHallServiceDesc,
				(
					Case 
						When SP.cd_servico is not null then SP.Dt_Ins
						else Null
					End
				) CitTransDateNF,
				
				(Case 
					When SP.cd_servico is null then ''
					else substring(ref_cnpj,9,4)
				 End
				) [07Invoice],
				
				(
					Case 
						When SP.cd_servico is not null then Doc_Number
						else Null
					End
				) DocumentNum,
				I.cd_tp_Tx Codigo_TX_ATL,
	(Case when TT.Tipo_Prod_Code = 1 then '850' else
	(
	Case LEFT(I.num_proc,2) 
	
		when 'IM' then 221
		when 'IA' then 122 
		when 'EA' then 112
		when 'EM' then 216
		when 'EO' then 411
		when 'IO' then 421
	End
	)End)Dimensao_2
			 From  Sol_Pgto_Cta_Cte_Item I with(nolock)
				Join Sol_Pgto_Cta_Cte SP with(nolock) on  I.ID=SP.ID
				Join House_imp_OUT Hou with(nolock) on hou.num_proc_hio=I.num_proc
				Join LLP_imp_OUT Job with(nolock) on Job.Num_Proc_Lio=Hou.Num_Proc_hio 
				Left Join Usuario US with(nolock) on US.Cd_Usuario = Job.cd_usuario 
				--Left Join Paridade PAR on PAR.Cd_Tp_Moeda = I.Cd_Tp_Moeda and I.Cd_Tp_Par = 'OFC' and Dt_Par = Dt_Conv
				Join Tipo_Taxa TT with(nolock) on  TT.Cd_Tp_Tx = I.Cd_Tp_Tx
				Left Join Tipo_Taxa_AX AX with(nolock) on  AX.Cd_Charge_AX = Cd_Ax_Resultado
				Left Join Tipo_TAxa_AX AXPT with(nolock) on  AXPT.cd_Charge_AX=cd_Ax_Repasse
				Join Pessoa PP with(nolock) on  PP.cd_pes=SP.cd_Cred_dev
				Left Join Pessoa_ATL_AX AXPP with(nolock) on  (AXPP.Cd_Pes = PP.Cd_Pes  ) and Tipo='F'
				Join dbo.AX_XML_Vendor_Recebido AV with(nolock) on  accountnum=axpp.cd_ax 
				--Left Join vwAXDocs IC on (IC.num_proc=I.num_proc and len(numerointernoax)=16 or I.num_proc=numerointernoAx and len(numerointernoAx)=14)and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
				Left Join vwAXDocs IC with(nolock) on IC.num_proc=I.num_proc and IC.cd_tp_Tx_ATL=I.cd_Tp_Tx and IC.Dc=I.dc
				Left Join referencia R with(nolock) on  R.ref_acesso=SP.ref_acesso
				Left Join Tipo_NF_Doc_Register TNDR with(nolock) on  SP.cd_servico = 	TNDR.cd_servico and SP.Item_lei = TNDR.Item_lei and SP.Ref_Acesso = TNDR.cd_site	
			 Where
				I.ID = @ID and IC.cd_tp_tx_Atl is NULL
		END
		*/
	
		
GO
