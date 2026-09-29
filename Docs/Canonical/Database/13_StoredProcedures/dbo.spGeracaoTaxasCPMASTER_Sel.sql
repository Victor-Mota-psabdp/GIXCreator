SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spGeracaoTaxasCPMASTER_Sel]'IAMAO201103009'

CREATE Procedure [dbo].[spGeracaoTaxasCPMASTER_Sel] --'IAMAO201301001'
			@Num_Proc	Varchar(14)
AS

--Declare @QtyContainer int
--Declare @Container20 int
--Declare @Container40 int
--Declare @Grupo	Varchar(10)


--Set @Container20=0
--SEt @Container40=0
--select * from Customer_profile 
if upper(left(@num_proc,2))='IM'
	Begin
--CONSOLIDADO - CLIENTE + ORIGEM + DESTINO			
			--create table @TEMP_CTA_CTE (
			Insert  CtA_cte_mas_imp_mar
			
			Select 
					@num_proc,CPT.cd_Tp_Tx,'D','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Compra,CPT.Vlr_Compra,convert(varchar(10),getdatE(),103),cd_fornecedor,
					'N','N','S','N','N','N',null,null,null,null,0,NULL,0,NULL,NULL,NULL,NULL 
			--INTO 
			--	#TEMP_CTA_CTE
			from 
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp and Modal = 'IM'
					Left Join cta_cte_mas_imp_mar CTA on cta.num_proc_mim=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_mim='D'		
					Join Master_Imp_Mar MAS on MAS.num_proc_Mim=@num_proc and cd_dst=cd_dst_Mim and cd_org= Cd_org_MIM and CP.CD_Cliente = MAS.Cd_Consig_MIM
					Join LLP_Master LLP	on	LLP.Num_proc_Master = MAS.Num_proc_Mim AND CP.Tipo_Carga = cd_tp_carga
			Where
					id_status_cp='1' 
					And Cd_Tipo_Compra='S'
					and cta.num_proc_mim is null
					and CP.Cd_Tipo_Servico='C'-- TAXAS LOCAIS	
----CONSOLIDADO - ORIGEN + DESTINO			
Union ALL

			Select 
					@num_proc,CPT.cd_Tp_Tx,'D','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Compra,CPT.Vlr_Compra,convert(varchar(10),getdatE(),103),cd_fornecedor,
					'N','N','S','N','N','N',null,null,null,null,0,NULL,0,NULL,NULL,NULL,NULL
			from 
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp and Modal = 'IM'
					Left Join cta_cte_mas_imp_mar CTA on cta.num_proc_mim=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_mim='D'		
					Join Master_Imp_Mar MAS on MAS.num_proc_Mim=@num_proc and cd_dst=cd_dst_Mim and cd_org= Cd_org_MIM
					Join LLP_Master LLP	on	LLP.Num_proc_Master = MAS.Num_proc_Mim AND CP.Tipo_Carga = cd_tp_carga
			Where
					id_status_cp='1' 
					And Cd_Tipo_Compra='S'
					and cta.num_proc_mim is null
					and CP.Cd_Tipo_Servico='C'-- TAXAS LOCAIS	
					--AND CD_CLIENTE=@Grupo
					--AND (CD_ORG IS NULL OR CD_ORG='ALL')
					
Union ALL
----CONSOLIDADO - DESTINO	
			Select 
					@num_proc,CPT.cd_Tp_Tx,'D','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Compra,CPT.Vlr_Compra,convert(varchar(10),getdatE(),103),cd_fornecedor,
					'N','N','S','N','N','N',null,null,null,null,0,NULL,0,NULL,NULL,NULL,NULL
			from 
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp and Modal = 'IM'
					Left Join cta_cte_mas_imp_mar CTA on cta.num_proc_mim=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_mim='D'		
					Join Master_Imp_Mar MAS on MAS.num_proc_Mim=@num_proc and cd_dst=cd_dst_Mim
					Join LLP_Master LLP	on	LLP.Num_proc_Master = MAS.Num_proc_Mim  AND CP.Tipo_Carga = cd_tp_carga
			Where
					id_status_cp='1'
					And Cd_Tipo_Compra='S'
					and cta.num_proc_mim is null
					and CP.Cd_Tipo_Servico='C'		
					--AND CD_CLIENTE=@Grupo
					AND (CD_ORG IS NULL OR CD_ORG='ALL')
					AND cd_cliente = 'P14935' --ALL
	End

Else
	if upper(left(@num_proc,2))='IA'
		Begin
		Declare @NJOB int
		Set @NJOB = (select Isnull(count(Num_proc_Hia),0) from House_imp_aer where Num_Proc_mia = @Num_Proc)
		If @NJOB <> 0
			Begin
				Begin

					--BUSCA EXATA - ORIGEM + DESTINO + IMPORTADOR
			Insert cta_cte_MAS_imp_aer
			--select top 1 * from cta_cte_Mas_imp_aer
					Select 
					@Num_Proc,CPT.cd_Tp_Tx,'D','CP',convert(varchar(10),getdatE(),103),Cd_Tp_Moeda_Compra,
					@NJOB*CPT.Vlr_Compra,convert(varchar(10),getdatE(),103),cd_consig_Mia,'N','N','S','N','N','N',
					null,null,null,null,0,0,0,0,null,0,null

					from 
							Customer_Profile_Taxas CPT
							Join Customer_Profile CP on CP.id_Cp=CPT.id_cp and Modal = 'IA'
							Left Join cta_cte_MAS_imp_aer CTA on cta.num_proc_Mia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_Mia='D'		
							Join MASTER_imp_aer MAS on MAS.num_proc_Mia=@num_proc and cd_consig_Mia=cd_cliente and MAS.num_proc_mia<> 'JOB' and cd_org=cd_org_Mia and cd_dst=cd_dst_Mia
					Where
							id_status_cp='1'
							And Cd_Tipo_Compra='S'
							and cta.num_proc_Mia is null
							and CP.Cd_Tipo_Servico='C'		
				
				End
				BEGIN		
					--BUSCA EXATA + DESTINO + IMPORTADOR
				Insert cta_cte_MAS_imp_aer 
				
					Select 
						@Num_Proc,CPT.cd_Tp_Tx,'D','CP',convert(varchar(10),getdatE(),103),Cd_Tp_Moeda_Compra,
						@NJOB*CPT.Vlr_Compra,convert(varchar(10),getdatE(),103),cd_consig_Mia,'N','N','S','N','N','N',
						null,null,null,null,0,0,0,0,null,0,null
					from 
							Customer_Profile_Taxas CPT
							Join Customer_Profile CP on CP.id_Cp=CPT.id_cp and Modal = 'IA'
							Left Join cta_cte_MAS_imp_aer  CTA on cta.num_proc_Mia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_Mia='D'		
							Join MASTER_imp_aer  MAS on MAS.num_proc_Mia=@num_proc and cd_consig_Mia=cd_cliente and MAS.num_proc_mia<> 'JOB' and cd_dst=cd_dst_Mia
					Where
							id_status_cp='1'
							And Cd_Tipo_Compra='S'
							and cta.num_proc_Mia is null
							and CP.Cd_Tipo_Servico='C'		
							AND (CD_ORG IS NULL OR CD_ORG='ALL')
				End
				BEGIN
					--BUSCA POR GRUPO E DESTINO
					
					--Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
					
			Insert cta_cte_MAS_imp_aer 
			
					Select 
						@Num_Proc,CPT.cd_Tp_Tx,'D','CP',convert(varchar(10),getdatE(),103),Cd_Tp_Moeda_Compra,
						@NJOB*CPT.Vlr_Compra,convert(varchar(10),getdatE(),103),cd_consig_Mia,'N','N','S','N','N','N',
						null,null,null,null,0,0,0,0,null,0,null
					from 
							Customer_Profile_Taxas CPT
							Join Customer_Profile CP on CP.id_Cp=CPT.id_cp and Modal = 'IA'
							Left Join cta_cte_MAS_imp_aer  CTA on cta.num_proc_Mia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_Mia='D'		
							Join MASTER_imp_aer  MAS on MAS.num_proc_Mia=@Num_Proc and cd_dst=cd_dst_Mia
					Where
							id_status_cp='1'
							And Cd_Tipo_Compra='S'
							and cta.num_proc_Mia is null
							and CP.Cd_Tipo_Servico='C'		
							--AND CD_CLIENTE=@Grupo
							AND (CD_ORG IS NULL OR CD_ORG='ALL')
							AND cd_cliente = 'P14935' --ALL
				END
			END
	END					
--select * from @TEMP_CTA_CTE
--		Begin
--			--Tarifas Gerais por Modal
						
--			Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
			
--			Insert CtA_cte_hou_imp_mar
	
--			Select 
--					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*[dbo].[Qty_Container_Tipo](@Num_Proc,'20'),convert(varchar(10),getdatE(),103),cd_consig_him,
--					'N',

--					case IVA
--						when 'N' then 'S'
--						else 'N'
--					end
--					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--			from 
--					Customer_Profile_Taxas CPT
--					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--					Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--					Join House_Imp_Mar hou on hou.num_proc_him=@num_proc 	
--					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc				
--			Where
--					id_status_cp='1'
--					And Cd_Tipo_Venda='V'
--					and cta.num_proc_him is null
--					and CP.Cd_Tipo_Servico='A'		
--					AND CD_CLIENTE=@Grupo
--					AND (cd_DST='ALL' and CD_ORG='ALL')
--					and [dbo].[Qty_Container_Tipo](@Num_Proc,'20') >0
--			Union All

						
--			Select 
--					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
--					'N',	
--						case IVA
--							when 'N' then 'S'
--							else 'N'
--						end
--					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--			From
--					Customer_Profile_Taxas CPT
--					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--					Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--					Join House_Imp_Mar hou on hou.num_proc_him=@num_proc 						
--					Join LLP_Imp_MAr LLP  on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc				
--			Where
--					id_status_cp='1'
--					And Cd_Tipo_Venda='J'
--					and cta.num_proc_him is null
--					and CP.Cd_Tipo_Servico='A'		
--					AND CD_CLIENTE=@Grupo
--					AND (cd_DST='ALL' and CD_ORG='ALL')
--			union all

--			Select 
--					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--					Cd_Tp_Moeda_Venda,

					
----					CAse 
----						When (PEso_Bruto_HIM/1000) > Vol_Tot_HIM then (PEso_Bruto_HIM/1000)*CPT.Vlr_Venda
----						Else Vol_Tot_HIM*CPT.Vlr_Venda
----					End
----incluido pr pegar o valor min de venda
----					CASE 
----						When (PEso_Bruto_HIM/1000) > Vol_Tot_HIM then 
----							(case when(PEso_Bruto_HIM/1000)*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
----									(PEso_Bruto_HIM/1000)*CPT.Vlr_Venda
----								else
----									CPT.Vlr_Min_Venda end)
----						Else (case when Vol_Tot_HIM*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
----								Vol_Tot_HIM*CPT.Vlr_Venda
----							else
----								CPT.Vlr_Min_Venda end)
----					END
----incluido pra comparar o min e o max de venda, qdo nao tem estes Min e Max, ele joga a  conta direto
--				(CASE 
--						When (PEso_Bruto_HIM/1000) > Vol_Tot_HIM then
--							(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
--								(PEso_Bruto_HIM/1000)*CPT.Vlr_Venda
--							Else
--								(case when(PEso_Bruto_HIM/1000)*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
--										(case when (PEso_Bruto_HIM/1000)*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
--											(PEso_Bruto_HIM/1000)*CPT.Vlr_Venda 
--										else
--											CPT.Vlr_Max_Venda 
--										end)								
--								else
--									CPT.Vlr_Min_Venda 
--								end)
--							End)
--					ELSE
--							(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
--								Vol_Tot_HIM*CPT.Vlr_Venda 
--							Else
--									(case when Vol_Tot_HIM*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
--											(case when Vol_Tot_HIM*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
--												Vol_Tot_HIM*CPT.Vlr_Venda 
--											else
--												CPT.Vlr_Max_Venda 
--											end)
--									else
--										CPT.Vlr_Min_Venda 
--									end)
--							End)
--					END)
--				,
--					convert(varchar(10),getdatE(),103),cd_consig_him,
--					'N',	
--						case IVA
--							when 'N' then 'S'
--							else 'N'
--						end
--					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--			From
--					Customer_Profile_Taxas CPT
--					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--					Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--					Join House_Imp_Mar hou on hou.num_proc_him=@num_proc 						
--					Join LLP_Imp_MAr LLP  on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc				


--			Where
--					id_status_cp='1'
--					And Cd_Tipo_Venda='T'
--					and cta.num_proc_him is null
--					and CP.Cd_Tipo_Servico='A'		
--					AND CD_CLIENTE=@Grupo
--					AND (cd_DST='ALL' and CD_ORG='ALL')

--			UNION ALL

--			Select 
--					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda * dbo.qty_container(@nUM_prOC),convert(varchar(10),getdatE(),103),cd_consig_him,
--					'N',

--					case IVA
--						when 'N' then 'S'
--						else 'N'
--					end
--					,


--					'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--			from 
--					Customer_Profile_Taxas CPT
--					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--					Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--					Join House_Imp_Mar hou on hou.num_proc_him=@num_proc 		
--					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc				
			
				
--			Where
--					id_status_cp='1'
--					And Cd_Tipo_Venda='C'
--					and cta.num_proc_him is null
--					and CP.Cd_Tipo_Servico='A'		
--					AND CD_CLIENTE=@Grupo
--					AND (cd_DST='ALL' and CD_ORG='ALL')
--					AND dbo.qty_container(@nUM_prOC) >0


--		End

--		Begin

--			--BUSCA EXATA - ORIGEM + DESTINO + IMPORTADOR
--			Insert CtA_cte_hou_imp_mar
	
--			Select 
--					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
--					'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--			from 
--					Customer_Profile_Taxas CPT
--					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--					Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--					Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_consig_him=cd_cliente and num_proc_mim <> 'JOB' and cd_org=cd_org_him and cd_dst=cd_dst_him
--			Where
--					id_status_cp='1'
--					And Cd_Tipo_Venda='J'
--					and cta.num_proc_him is null
--					and CP.Cd_Tipo_Servico='A'		
		
--		End
--		BEGIN		
--			--BUSCA EXATA + DESTINO + IMPORTADOR
--			Insert CtA_cte_hou_imp_mar
	
--			Select 
--					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
--					'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--			from 
--					Customer_Profile_Taxas CPT
--					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--					Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--					Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_consig_him=cd_cliente and num_proc_mim <> 'JOB' and cd_dst=cd_dst_him
--			Where
--					id_status_cp='1'
--					And Cd_Tipo_Venda='J'
--					and cta.num_proc_him is null
--					and CP.Cd_Tipo_Servico='A'		
--					AND (CD_ORG IS NULL OR CD_ORG='ALL')
--		End


--		BEGIN
--			--BUSCA POR GRUPO E DESTINO
			
--			Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
			
--			Insert CtA_cte_hou_imp_mar
	
--			Select 
--					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
--					'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--			from 
--					Customer_Profile_Taxas CPT
--					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--					Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--					Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_dst=cd_dst_him
--			Where
--					id_status_cp='1'
--					And Cd_Tipo_Venda='J'
--					and cta.num_proc_him is null
--					and CP.Cd_Tipo_Servico='A'		
--					AND CD_CLIENTE=@Grupo
--					AND (CD_ORG IS NULL OR CD_ORG='ALL')

--		END
	
--		Set @QtyContainer=(select dbo.qty_container(@Num_Proc))
--		if @QtyContainer > 0 
--			Begin
--				Begin
--					Insert CtA_cte_hou_imp_mar
--					Select 
--							@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--							Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*@QtyContainer,convert(varchar(10),getdatE(),103),cd_consig_him,
--							'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--					from 
--							Customer_Profile_Taxas CPT
--							Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--							Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--							Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_consig_him=cd_cliente and num_proc_mim <> 'JOB' and cd_org=cd_org_him and cd_dst=cd_dst_him
--					Where
--							id_status_cp='1'
--							And Cd_Tipo_Venda='C'
--							and cta.num_proc_him is null
--							and CP.Cd_Tipo_Servico='A'		
				
--				End
--				BEGIN		
--					--BUSCA EXATA + DESTINO + IMPORTADOR
--					Insert CtA_cte_hou_imp_mar
			
--					Select 
--							@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--							Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*@QtyContainer,convert(varchar(10),getdatE(),103),cd_consig_him,
--							'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--					from 
--							Customer_Profile_Taxas CPT
--							Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--							Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--							Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_consig_him=cd_cliente and num_proc_mim <> 'JOB' and cd_dst=cd_dst_him
--					Where
--							id_status_cp='1'
--							And Cd_Tipo_Venda='C'
--							and cta.num_proc_him is null
--							and CP.Cd_Tipo_Servico='A'		
--							AND (CD_ORG IS NULL OR CD_ORG='ALL')
--				End


--				BEGIN
--					--BUSCA POR GRUPO E DESTINO
					
--					Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
					
--					Insert CtA_cte_hou_imp_mar
			
--					Select 
--							@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--							Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*@QtyContainer,convert(varchar(10),getdatE(),103),cd_consig_him,
--							'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--					from 
--							Customer_Profile_Taxas CPT
--							Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--							Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--							Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_dst=cd_dst_him
--					Where
--							id_status_cp='1'
--							And Cd_Tipo_Venda='C'
--							and cta.num_proc_him is null
--							and CP.Cd_Tipo_Servico='A'		
--							AND CD_CLIENTE=@Grupo
--							AND (CD_ORG IS NULL OR CD_ORG='ALL')

--				END
--			End
--				Set @Container20=
--					(select count(num_proc_him) from container_hou_imp_mar CH
--					Join Container_Mas_Imp_Mar CM on CM.num_proC_mim=CH.num_proc_mim and CM.item_cont_im=CH.item_cont_im
--					Where
--						left(cd_tp_cont,2)='20' and num_proc_him=@num_proc)
		
--				if @Container20 >0 and @Container20 is not null
--				 Begin
--					Begin
-----INICIO PARA CONTAINER 20						
--					Insert CtA_cte_hou_imp_mar
--						Select 
--								@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--								Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*@Container20,convert(varchar(10),getdatE(),103),cd_consig_him,
--								'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--						from 
--								Customer_Profile_Taxas CPT
--								Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--								Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--								Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_consig_him=cd_cliente and num_proc_mim <> 'JOB' and cd_org=cd_org_him and cd_dst=cd_dst_him
--						Where
--								id_status_cp='1'
--								And Cd_Tipo_Venda='V'
--								and cta.num_proc_him is null
--								and CP.Cd_Tipo_Servico='A'		
					
--					End
--					BEGIN		
--						--BUSCA EXATA + DESTINO + IMPORTADOR
--						Insert CtA_cte_hou_imp_mar
				
--						Select 
--								@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--								Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*@Container20,convert(varchar(10),getdatE(),103),cd_consig_him,
--								'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--						from 
--								Customer_Profile_Taxas CPT
--								Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--								Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--								Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_consig_him=cd_cliente and num_proc_mim <> 'JOB' and cd_dst=cd_dst_him
--						Where
--								id_status_cp='1'
--								And Cd_Tipo_Venda='V'
--								and cta.num_proc_him is null
--								and CP.Cd_Tipo_Servico='A'		
--								AND (CD_ORG IS NULL OR CD_ORG='ALL')
--					End


--					BEGIN
--						--BUSCA POR GRUPO E DESTINO
						
						
--						Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
						
--						Insert CtA_cte_hou_imp_mar
				
--						Select 
--								@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--								Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*@Container20,convert(varchar(10),getdatE(),103),cd_consig_him,
--								'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--						from 
--								Customer_Profile_Taxas CPT
--								Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--								Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--								Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_dst=cd_dst_him
--						Where
--								id_status_cp='1'
--								And Cd_Tipo_Venda='V'
--								and cta.num_proc_him is null
--								and CP.Cd_Tipo_Servico='A'		
--								AND CD_CLIENTE=@Grupo
--								AND (CD_ORG IS NULL OR CD_ORG='ALL')

--					END

--					End

--				Set @Container20=
--					(select count(num_proc_him) from container_hou_imp_mar CH
--					Join Container_Mas_Imp_Mar CM on CM.num_proC_mim=CH.num_proc_mim and CM.item_cont_im=CH.item_cont_im
--					Where
--						left(cd_tp_cont,2)='40' and num_proc_him=@num_proc)
		
--				if @Container20 >0 and @Container20 is not null
--				 Begin
--					Begin
-----INICIO PARA CONTAINER 40						
--						Select 
--								@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--								Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*@Container20,convert(varchar(10),getdatE(),103),cd_consig_him,
--								'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--						from 
--								Customer_Profile_Taxas CPT
--								Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--								Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--								Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_consig_him=cd_cliente and num_proc_mim <> 'JOB' and cd_org=cd_org_him and cd_dst=cd_dst_him
--						Where
--								id_status_cp='1'
--								And Cd_Tipo_Venda='Q'
--								and cta.num_proc_him is null
--								and CP.Cd_Tipo_Servico='A'		
					
--					End
--					BEGIN		
--						--BUSCA EXATA + DESTINO + IMPORTADOR
--						Insert CtA_cte_hou_imp_mar
				
--						Select 
--								@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--								Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*@Container20,convert(varchar(10),getdatE(),103),cd_consig_him,
--								'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--						from 
--								Customer_Profile_Taxas CPT
--								Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--								Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--								Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_consig_him=cd_cliente and num_proc_mim <> 'JOB' and cd_dst=cd_dst_him
--						Where
--								id_status_cp='1'
--								And Cd_Tipo_Venda='Q'
--								and cta.num_proc_him is null
--								and CP.Cd_Tipo_Servico='A'		
--								AND (CD_ORG IS NULL OR CD_ORG='ALL')
--					End


--					BEGIN
--						--BUSCA POR GRUPO E DESTINO	
						
--						Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
						
--						Insert CtA_cte_hou_imp_mar
				
--						Select 
--								@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
--								Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*@Container20,convert(varchar(10),getdatE(),103),cd_consig_him,
--								'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
--						from 
--								Customer_Profile_Taxas CPT
--								Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
--								Left Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
--								Join House_Imp_Mar hou on hou.num_proc_him=@num_proc and cd_dst=cd_dst_him
--						Where
--								id_status_cp='1'
--								And Cd_Tipo_Venda='V'
--								and cta.num_proc_him is null
--								and CP.Cd_Tipo_Servico='Q'		
--								AND CD_CLIENTE=@Grupo
--								AND (CD_ORG IS NULL OR CD_ORG='ALL')

--					END


--					End


					
--	End
		








GO
