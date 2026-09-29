SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spGeracaoTaxasCP_IA_Sel] 'IAGVD201505050BR'
CREATE Procedure [dbo].[spGeracaoTaxasCP_IA_Sel_1111] 

@Num_Proc	Varchar(16)

AS

--Declare @Grupo	Varchar(10)

Begin /**Cria Por Cliente**/

	Begin /**Origem ALL**/
	
		Insert cta_cte_hou_imp_Aer
		
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
				Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.num_proc_hia=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
				Join House_Imp_Aer hou on hou.num_proc_hia=@Num_Proc and  cd_consig_hia=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIA
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
	
		Insert CtA_cte_hou_imp_Aer
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
				Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.num_proc_hia=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
	
		Insert	cta_cte_hou_imp_Aer		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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
				Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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
				Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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
		
		Insert	cta_cte_hou_imp_Aer
		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
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
				Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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
				Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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
				Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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

		insert Cta_Cte_Hou_Imp_Aer
		
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
				Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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
				Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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



/*antigo stored

ALTER Procedure [dbo].[spGeracaoTaxasCP_IA_Sel] 

@Num_Proc	Varchar(16)
AS

--Declare @Grupo	Varchar(10)

Begin /**Cria Por Cliente**/
	Begin /**Origem ALL**/
			Insert CtA_cte_hou_imp_Aer

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
						Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.num_proc_hia=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@Num_Proc and  cd_consig_hia=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIA
						Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_hia is null
						--and CP.Cd_Tipo_Servico='B'
						AND (CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'	
union all

--Calculo por LI
								
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente	and CP.Cd_Dst = HOU.Cd_Dst_HIA
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc 
						Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI = 4
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						--and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'EEL'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

			union all	
--Calculo por SUB LI
								
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente	and CP.Cd_Dst = HOU.Cd_Dst_HIA
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc 
						Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI <> 4
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						--and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'SUB'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA
union all

--Calculo por Certificado de Origem
								
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 	and  cd_consig_hia=cd_cliente	 and CP.Cd_Dst = HOU.Cd_Dst_HIA				
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
						Join PO_hia P13 on P13.ID_DC = '13' and P13.Num_Proc_hia = @Num_Proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						--and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'ECO'
						--and TT.Nome_Tp_Tx = 'Certificado de Origem'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA	

union all
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente	and CP.Cd_Dst = HOU.Cd_Dst_HIA		
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx						
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')
	End  /**Origem ALL**/
	Begin /**Origem e Destino ALL**/
		Insert CtA_cte_hou_imp_Aer

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
						Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.num_proc_hia=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@Num_Proc and  cd_consig_hia=cd_cliente
						Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_hia is null
						--and CP.Cd_Tipo_Servico='B'
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IA'	
union all

--Calculo por LI
								
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc 
						Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI <> 4
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						--and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'EEL'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

			union all	
--Calculo por SUB LI
								
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc 
						Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI <> 4
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						--and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'SUB'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA
union all

--Calculo por Certificado de Origem
								
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 	and  cd_consig_hia=cd_cliente			
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
						Join PO_hia P13 on P13.ID_DC = '13' and P13.Num_Proc_hia = @Num_Proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						--and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'ECO'
						--and TT.Nome_Tp_Tx = 'Certificado de Origem'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA	

union all
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and  cd_consig_hia=cd_cliente	
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx						
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')

	End  /**Origem e Destino ALL**/
End /**Cria Por Cliente**/

Begin /**Cria Por Grupo*/
	Begin /**Origem ALL**/	
	--Calculo por LI
				Insert	cta_cte_hou_imp_Aer			
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HIA							
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
						Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI <> 4
						join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'EEL'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA
	union all
	
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc  and CP.Cd_Dst = HOU.Cd_Dst_HIA								
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
						Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI = 4
						join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'SUB'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA
							

--Calculo por Certificado de Origem
union all
			
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HIA		 						
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
						Join PO_hia P13 on P13.ID_DC = '13' and P13.Num_Proc_hia = @Num_Proc
						join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'ECO'
						--and TT.Nome_Tp_Tx = 'Certificado de Origem'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

--Documento
union all
		
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc  and CP.Cd_Dst = HOU.Cd_Dst_HIA								
						Join LLP_Imp_Aer LLP  on num_proC_lia=@num_proc
						Join Grupo GP on GP.Cd_Pes_Grupo = CP.Cd_Cliente
						join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx						
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')
						--and TT.Nome_Tp_Tx  not in ('Emissão de LI','Certificado de Origem')
union all
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
					Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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
					--AND CD_CLIENTE=@Grupo
					AND (CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IA'
					and CPT.Cd_Tp_Tx = 'SR2'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

union all
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
					Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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
					--AND CD_CLIENTE=@Grupo
					AND (CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IA'
					and CPT.Cd_Tp_Tx = 'SRV'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

union all
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
					Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
					Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc  and CP.Cd_Dst = HOU.Cd_Dst_HIA	
					Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc	
					join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hia is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IA'
					and CPT.Cd_Tp_Tx not in('SR2','SRV')
					
End /**OrigemALL**/
	Begin /**Origem e Destino ALL**/	
	--Calculo por LI
				Insert	cta_cte_hou_imp_Aer			
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 						
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
						Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI <> 4
						join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'EEL'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA
	union all
	
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 						
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
						Join Solicitacao_LI SLI on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI = 4
						join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'SUB'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA
							

--Calculo por Certificado de Origem
union all
			
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 						
						Join LLP_Imp_Aer LLP  on  num_proC_lia=@num_proc
						Join PO_hia P13 on P13.ID_DC = '13' and P13.Num_Proc_hia = @Num_Proc
						join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx = 'ECO'
						--and TT.Nome_Tp_Tx = 'Certificado de Origem'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

--Documento
union all
		
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
						Left Join cta_cte_hou_imp_Aer CTA on cta.num_proc_hia=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hia='C'		
						Join House_Imp_Aer hou on hou.num_proc_hia=@num_proc 						
						Join LLP_Imp_Aer LLP  on num_proC_lia=@num_proc
						Join Grupo GP on GP.Cd_Pes_Grupo = CP.Cd_Cliente
						join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx						
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hia is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IA'
						and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')
						--and TT.Nome_Tp_Tx  not in ('Emissão de LI','Certificado de Origem')

union all
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
					Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IA'
					and CPT.Cd_Tp_Tx = 'SR2'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

union all
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
					Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
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
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IA'
					and CPT.Cd_Tp_Tx = 'SRV'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hia,IVA

union all
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
					Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
					Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc
					Join LLP_Imp_Aer LLP with(nolock) on  num_proC_lia=@num_proc	
					join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hia is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IA'
					and CPT.Cd_Tp_Tx not in('SR2','SRV')
					
End /**Origem e Destino ALL**/
End /**Cria Por Grupo*/

Begin /**Regras Gerais**/
insert Cta_Cte_Hou_Imp_Aer
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
					Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
					Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc
					Join LLP_Imp_Aer LLP with(nolock) on num_proC_lia=@num_proc		
					join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente						
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hia is null
					and CP.Cd_Tipo_Servico='A'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IA'

Union all
						
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
					Left Join Cta_Cte_Hou_Imp_Aer CTA on cta.Num_Proc_hia=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_hia='C'		
					Join House_Imp_Aer hou on hou.Num_Proc_hia=@Num_Proc
					Join LLP_Imp_Aer LLP with(nolock) on num_proC_lia=@num_proc	
					join Pessoa_LLP PL on HOU.Cd_Consig_hia = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hia is null
					and CP.Cd_Tipo_Servico='C'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IA'
End /**Regras Gerais**/


*/
GO
