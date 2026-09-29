SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spGeracaoTaxasCP_IA_LOG_Sel] 'IAGVD201505050BR'
create Procedure [dbo].[spGeracaoTaxasCP_IA_Sel] 

@Num_Proc	Varchar(16),
@Cd_Usuario varchar(6)

AS

Declare @CtaCte table(
Num_Proc_HIA varchar(16),
Cd_Tp_Tx varchar(3),
DC_HIA char(1),
Org_Ins_HIA varchar(9),
Dt_Ins_HIA varchar(10),
Cd_Tp_Moeda varchar(3),
Vlr_Org_HIA decimal(10, 2),
Dt_Prev_Pgto_HIA varchar(10),
Cd_Cred_Dev_HIA varchar(10),
Desp_Org_HIA char(1),
CPMF_HIA char(1),
Comp_RP_HIA char(1),
Comp_DN_HIA char(1),
Comp_CN_HIA char(1),
Comp_CPA_HIA char(1),
Num_DCN_HIA varchar(12),
Dt_Ctb_CC_HIA varchar(10),
Num_NF_HIA varchar(12),
Ref_Acesso_NF_HIA char(1),
Vlr_Pgto_NF_HIA decimal(18, 2),
Par_NF_HIA float,
Comp_Job_HIA char(1),
Contab bit,
Vlr_Contab decimal(12, 2),
Contab_Ant bit,
Vlr_Contab_Ant decimal(12, 2),
Contab_Mes_Ano varchar(7),
Val_Con_Comp decimal(12, 2)
)

Begin /**Cria Por Cliente**/

	Begin /**Origem ALL**/
	
		Insert @CtaCte
		
			--Tipo venda JOB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.num_proc_hia=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou with(nolock) on hou.num_proc_hia=@Num_Proc and  cd_consig_hia=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIA
				Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'	

		UNION ALL
		
		--Inspeção de Madeira nao tem

		--Emissão de LI								
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente	and CP.Cd_Dst = HOU.Cd_Dst_HIA
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc 
				Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI = 4								
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'EEL'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

		UNION ALL
			
		--LI SUB								
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente	and CP.Cd_Dst = HOU.Cd_Dst_HIA
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc 
				Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI <> 4							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'SUB'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

		UNION ALL

		--Certificado de Origem
								
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_hia),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 	and  cd_consig_hia=cd_cliente	 and CP.Cd_Dst = HOU.Cd_Dst_HIA				
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
				Join PO_hia P13 on P13.ID_DC = '13' and P13.Num_Proc_hia = @Num_Proc
				--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'ECO'				
			group by
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA	

		UNION ALL
		
		--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente	and CP.Cd_Dst = HOU.Cd_Dst_HIA		
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc									
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')
				
	End  /**Origem ALL**/
	
	Begin /**Origem e Destino ALL**/
	
		Insert @CtaCte
			--Tipo venda JOB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@Num_Proc and  cd_consig_hia=cd_cliente
				Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'					
			
		UNION ALL
			--Inspeção de Madeira nao tem
			
			--Emissão de LI
								
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc 
				Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI <> 4							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'EEL'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

		UNION ALL
			
			--LI SUB								
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc 
				Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI <> 4								
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'	
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'SUB'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

		UNION ALL

			--Certificado de Origem								
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_hia),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and cd_consig_hia=cd_cliente			
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
				Join PO_hia P13 on P13.ID_DC = '13' and P13.Num_Proc_hia = @Num_Proc							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'ECO'					
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA	

		UNION ALL
		
			--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente	
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')

	End  /**Origem e Destino ALL**/
	
End /**Cria Por Cliente**/

Begin /**Cria Por Grupo*/

	Begin /**Origem ALL**/
	
		Insert	@CtaCte		
			--Inspeção de Madeira nao tem
			
			--Emissão de LI					
			Select 
				 @Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HIA							
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
				Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI <> 4
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'EEL'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

		UNION ALL
			
			--LI SUB
			Select 
				 @Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc  and CP.Cd_Dst = HOU.Cd_Dst_HIA								
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
				Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI = 4
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'SUB'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA
							

		UNION ALL
		
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_hia),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HIA		 						
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
				Join PO_hia P13 on P13.ID_DC = '13' and P13.Num_Proc_hia = @Num_Proc
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente								
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'ECO'				
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA
		
		UNION ALL
		
			--Documento		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc  and CP.Cd_Dst = HOU.Cd_Dst_HIA								
				Join LLP_Imp_Aer LLP  on num_proC_lia=@num_proc
				Join Grupo GP on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente								
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')				

		UNION ALL
		
			--Serviços Prestados - SAMPLE
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
				Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc  and CP.Cd_Dst = HOU.Cd_Dst_HIA	
				Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente	
				Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 						
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'
				and CPT.Cd_Tp_Tx = 'SR2'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

		UNION ALL

			--Serviços Prestados - PO	
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
				Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc  and CP.Cd_Dst = HOU.Cd_Dst_HIA	
				Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente	
				Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 						
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'
				and CPT.Cd_Tp_Tx = 'SRV'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

		UNION ALL
		
			--Tipo venda JOB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
				Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc  and CP.Cd_Dst = HOU.Cd_Dst_HIA	
				Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
					
	End /**OrigemALL**/
	
	Begin /**Origem e Destino ALL**/
		
		Insert	@CtaCte
		
			--Inspeção de Madeira nao tem
			--Emissão de LI		
			Select 
				 @Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 						
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
				Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI <> 4
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente								
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'EEL'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA
				
		UNION ALL
			
			--LI SUB
			Select 
				 @Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 						
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
				Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI = 4
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente								
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'SUB'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA
							

		UNION ALL
		
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_hia),convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 						
				Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
				Join PO_hia P13 on P13.ID_DC = '13' and P13.Num_Proc_hia = @Num_Proc
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'	
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx = 'ECO'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

		UNION ALL
		
			--Documento		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 						
				Join LLP_Imp_Aer LLP  on num_proC_lia=@num_proc
				Join Grupo GP on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IA'
				and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')				

		UNION ALL
			
			--Serviços Prestados - SAMPLE
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
				Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc
				Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente	
				Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 						
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'
				and CPT.Cd_Tp_Tx = 'SR2'
			group by
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

		UNION ALL
		
			--Serviços Prestados - PO	
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
				Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc
				Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente	
				Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 						
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'	
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'
				and CPT.Cd_Tp_Tx = 'SRV'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

		UNION ALL
			
			--Tpo Venda JOB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
				Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc
				Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
					
	End /**Origem e Destino ALL**/
	
End /**Cria Por Grupo*/

Begin /**Regras Gerais**/

		insert @CtaCte
		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
				Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc
				Join LLP_Imp_Aer LLP with(nolock) on num_proC_lia=@num_proc		
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente						
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='A'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'

		UNION ALL
						
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hia,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
				Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc
				Join LLP_Imp_Aer LLP with(nolock) on num_proC_lia=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hia is null
				and CP.Cd_Tipo_Servico='C'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'
				
End /**Regras Gerais**/



delete Temp from @CtaCte Temp
Join Cta_Cte_Hou_Imp_Aer CTA on Temp.Num_Proc_HIA= CTA.Num_Proc_HIA  and Temp.cd_tp_Tx=CTA.cd_tp_tx and Temp.Dc_hia=CTA.DC_HIA

insert Cta_Cte_Hou_Imp_Aer
select Num_Proc_HIA,
Cd_Tp_Tx,
DC_HIA,
Org_Ins_HIA,
Dt_Ins_HIA,
Cd_Tp_Moeda,
Vlr_Org_HIA,
Dt_Prev_Pgto_HIA,
Cd_Cred_Dev_HIA,
Desp_Org_HIA,
CPMF_HIA,
Comp_RP_HIA,
Comp_DN_HIA,
Comp_CN_HIA,
Comp_CPA_HIA,
Num_DCN_HIA,
Dt_Ctb_CC_HIA,
Num_NF_HIA,
Ref_Acesso_NF_HIA,
Vlr_Pgto_NF_HIA,
Par_NF_HIA,
Comp_Job_HIA,
Contab,
Vlr_Contab,
Contab_Ant,
Vlr_Contab_Ant,
Contab_Mes_Ano,
Val_Con_Comp from @CtaCte


insert Log_Cta_Cte
select 
getdate(),
@Cd_Usuario,
'I',
Num_Proc_HIA,
Cd_Tp_Tx,
DC_HIA,
Org_Ins_HIA,
Dt_Ins_HIA,
Cd_Tp_Moeda,
Vlr_Org_HIA,
Dt_Prev_Pgto_HIA,
Cd_Cred_Dev_HIA,
Desp_Org_HIA,
CPMF_HIA,
Comp_RP_HIA,
Comp_DN_HIA,
Comp_CN_HIA,
Comp_CPA_HIA,
Contab,
Vlr_Contab,
Contab_Ant,
Contab_Mes_Ano from @CtaCte
GO
