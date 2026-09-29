SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spGeracaoTaxasCP_IO_Sel_1111] --'IMFMC201408049BR'
(
		@Num_Proc	Varchar(16)
)

AS	

Begin /**Cria Por Cliente**/

	Begin /**Origem ALL**/
	
		insert CtA_cte_hou_imp_out
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_cte_hou_imp_out CTA with(nolock) on cta.num_proc_hio=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@Num_Proc and  Cd_Consig_HIO=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIO
				Join LLP_Imp_Out LLP with(nolock) on num_proC_lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and	
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'
						
			--Inspeção de Madeira nao tem no IO
				
		UNION ALL
			
			--Emissão de LI
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_hio,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_cte_hou_imp_out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.num_proc_hio=@num_proc and Cd_Consig_HIO=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIO				
				Join LLP_Imp_Out LLP  with(nolock) on Num_Proc_Lio=@num_proc  -- LLP.cd_tp_Carga=cp.tipo_carga	and
				Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI <> 4									
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hio is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'EEL'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA
						
		UNION ALL
	
			--LI SUB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_cte_hou_imp_out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
				Join House_Imp_Out hou with(nolock)  on hou.num_proc_hio=@num_proc 		and  Cd_Consig_HIO=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIO				
				Join LLP_Imp_Out LLP with(nolock) on  Num_Proc_Lio=@num_proc  --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI = 4									
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'SUB'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA
						
		UNION ALL

			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HIO),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_cte_hou_imp_out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc 	and  Cd_Consig_HIO=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIO					
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join PO_HIO P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HIO = @Num_Proc										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'ECO'				
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA
						
		UNION All

			--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_cte_hou_imp_out CTA with(nolock) on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.num_proc_hio=@num_proc and  Cd_Consig_HIO=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIO			
				Join LLP_Imp_Out LLP  with(nolock) on Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'				
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')

	End /**Origem ALL**/
	
	Begin /**Origem and Destino ALL**/
	
		insert Cta_Cte_Hou_Imp_Out
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.num_proc_hio=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.num_proc_hio=@Num_Proc and  Cd_Consig_HIO=cd_cliente
				Join LLP_Imp_Out LLP with(nolock) on  Num_Proc_Lio=@num_proc	 --LLP.cd_tp_Carga=cp.tipo_carga	and
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hio is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'	

			--Inspeção de Madeira nao tem no IO
			
		UNION ALL	
		
			--Emissão de LI
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc and Cd_Consig_HIO=cd_cliente				
				Join LLP_Imp_Out LLP  with(nolock) on  Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI <> 4									
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'	
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'EEL'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA
				
		UNION ALL
		
			--LI SUB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc 		and  Cd_Consig_HIO=cd_cliente				
				Join LLP_Imp_Out LLP  with(nolock) on LLP.Num_Proc_Lio=@num_proc  --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI = 4								
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'	
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'SUB'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA

		UNION ALL
			
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HIO),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc 	and  Cd_Consig_HIO=cd_cliente					
				Join LLP_Imp_Out LLP  with(nolock) on Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join PO_HIO P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HIO = @Num_Proc										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'ECO'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA

		UNION ALL
			
			--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc and Cd_Consig_HIO=cd_cliente			
				Join LLP_Imp_Out LLP  with(nolock) on  Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and												
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'	
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')

	End /**Origem and Destino ALL**/
	
End /**Cria Por Cliente**/

Begin /**Cria Por Grupo*/

	Begin /**Origem  ALL**/
	
		insert Cta_Cte_Hou_Imp_Out
		
			--Inspeção de Madeira nao tem no IO
		
			--Emissão de LI					
			Select 
				 @Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc 	and CP.Cd_Dst = HOU.Cd_Dst_HIO					
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI <> 4
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'EEL'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA

		UNION ALL
		
			--LI SUB
			Select 
				 @Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HIO						
				Join LLP_Imp_Out LLP  with(nolock) on Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI = 4
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'SUB'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA	
		
		UNION ALL	
		
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HIO),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HIO						
				Join LLP_Imp_Out LLP  with(nolock) on Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and 
				Join PO_HIO P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HIO = @Num_Proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hio is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'ECO'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA
				
		UNION ALL
			
			--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HIO						
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente									
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'					
				and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')
				
		UNION ALL
		
			--Serviços Prestados - SAMPLE
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@Num_Proc and CP.Cd_Dst = HOU.Cd_Dst_HIO
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc	--LLP.cd_tp_Carga=cp.tipo_carga	and
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'							
				and CPT.Cd_Tp_Tx = 'SR2'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA

		UNION ALL
		
			--Serviços Prestados - PO		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@Num_Proc and CP.Cd_Dst = HOU.Cd_Dst_HIO
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc	--LLP.cd_tp_Carga=cp.tipo_carga	and
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'							
				and CPT.Cd_Tp_Tx = 'SRV'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA
				
		union all
		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@Num_Proc and CP.Cd_Dst = HOU.Cd_Dst_HIO
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc	 -- LLP.cd_tp_Carga=cp.tipo_carga	and
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
		
	End /**Origem ALL**/
	
	Begin /**Origem and Destino ALL**/
	
		insert Cta_Cte_Hou_Imp_Out
			
			--Inspeção de Madeira nao tem no IO

			--Emissão de LI
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc 						
				Join LLP_Imp_Out LLP  with(nolock) on Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI <> 4
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'EEL'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA
				
		UNION ALL
			
			--LI SUB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc 						
				Join LLP_Imp_Out LLP  with(nolock) on Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI = 4
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'SUB'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA	
		
		UNION ALL
				
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HIO),convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc 						
				Join LLP_Imp_Out LLP  with(nolock) on Num_Proc_Lio=@num_proc -- LLP.cd_tp_Carga=cp.tipo_carga	and 
				Join PO_HIO P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HIO = @Num_Proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx = 'ECO'	
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA

		UNION ALL
			
			--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@num_proc 						
				Join LLP_Imp_Out LLP  with(nolock) on Num_Proc_Lio=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente				
		Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IO'
				and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')
				
		UNION ALL
		
			--Serviços Prestados - SAMPLE
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@Num_Proc
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc	 --LLP.cd_tp_Carga=cp.tipo_carga	and
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'							
				and CPT.Cd_Tp_Tx = 'SR2'
			group by
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA

		UNION ALL
		
			--Serviços Prestados - PO		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@Num_Proc
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc	 --LLP.cd_tp_Carga=cp.tipo_carga	and 
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'		
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'							
				and CPT.Cd_Tp_Tx = 'SRV'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Consig_HIO,IVA
				
		UNION ALL
			
			--		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@Num_Proc
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc	 --LLP.cd_tp_Carga=cp.tipo_carga	and 
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='B'		
				--AND CD_CLIENTE=@Grupo
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
		
	End /**Origem and Destino ALL**/
	
End /**Cria Por Grupo*/

Begin /**Regras Gerais**/

	insert Cta_Cte_Hou_Imp_Out
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@Num_Proc
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc		--LLP.cd_tp_Carga=cp.tipo_carga	and 
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='A'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'
				
		UNION ALL
			
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,
				(CASE 
						When (Peso_Bruto_HIO/1000) > Vol_Tot_HIO then
							(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
								(PEso_Bruto_HIO/1000)*CPT.Vlr_Venda
							Else
								(case when(Peso_Bruto_HIO/1000)*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
										(case when (PEso_Bruto_HIO/1000)*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
											(Peso_Bruto_HIO/1000)*CPT.Vlr_Venda 
										else
											CPT.Vlr_Max_Venda 
										end)								
								else
									CPT.Vlr_Min_Venda 
								end)
							End)
					ELSE
							(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
								Vol_Tot_HIO*CPT.Vlr_Venda 
							Else
									(case when Vol_Tot_HIO*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
											(case when Vol_Tot_HIO*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
												Vol_Tot_HIO*CPT.Vlr_Venda 
											else
												CPT.Vlr_Max_Venda 
											end)
									else
										CPT.Vlr_Min_Venda 
									end)
							End)
					END)
				,convert(varchar(10),getdatE(),103),cd_consig_hio,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@Num_Proc
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc		--LLP.cd_tp_Carga=cp.tipo_carga	and 
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente	
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='K'
				and cta.num_proc_hio is null
				and CP.Cd_Tipo_Servico='A'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'				

		UNION ALL
						
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Consig_HIO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA with(nolock) on cta.Num_Proc_HIO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIO='C'		
				Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=@Num_Proc
				Join LLP_Imp_Out LLP with(nolock) on Num_Proc_Lio=@num_proc	 --LLP.cd_tp_Carga=cp.tipo_carga	and 
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HIO is null
				and CP.Cd_Tipo_Servico='C'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='IO'
					
End /**Regras Gerais**/




/*
ALTER Procedure [dbo].[spGeracaoTaxasCP_IO_Sel]
			@Num_Proc	Varchar(16)
AS

Declare @Grupo	Varchar(10)

Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	

if upper(left(@num_proc,2))='IO'
	BEGIN	

	--Calculo por LI
		Declare @LI int			
		set @LI =(select COUNT(ID_PO_hio) from PO_hio where ID_DC = '23' and Num_Proc_hio = @Num_Proc)		
		If @LI >0
			begin
				Insert CtA_cte_hou_imp_out
							
				Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,
				CPT.Vlr_Venda*@LI,convert(varchar(10),getdatE(),103),
				cd_consig_hio,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_imp_out CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
						Join House_Imp_Out hou on hou.num_proc_hio=@num_proc 						
						Join LLP_Imp_out LLP  on 	 num_proC_lio=@num_proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hio is null
						and CP.Cd_Tipo_Servico='B'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IO'
						and CPT.Cd_Tp_Tx = 'EEL'
--							and TT.Nome_Tp_Tx = 'EEL'
						
			end				
				
	--Calculo por Certificado de Origem
		Declare @CO int			
		set @CO =(select COUNT(ID_PO_hio) from PO_hio where ID_DC = '13' and Num_Proc_hio = @Num_Proc)			
		If @CO >0
			begin
				Insert CtA_cte_hou_imp_out
							
				Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,
				CPT.Vlr_Venda*@CO,convert(varchar(10),getdatE(),103),
				cd_consig_hio,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_imp_out CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
						Join House_Imp_out hou on hou.num_proc_hio=@num_proc 						
						Join LLP_Imp_out LLP  on LLP.num_proC_lio=@num_proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_hio is null
						and CP.Cd_Tipo_Servico='B'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IO'
						and CPT.Cd_Tp_Tx = 'ECO'
						--and TT.Nome_Tp_Tx = 'Certificado de Origem'
			end			
			
	--Documento
		Begin
		Insert CtA_cte_hou_imp_out			
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					cd_consig_hio,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_imp_out CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
					Join House_Imp_out hou on hou.num_proc_hio=@num_proc 						
					Join LLP_Imp_out LLP  on LLP.num_proC_lio=@num_proc
					--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx						
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='D'
					and cta.num_proc_hio is null
					and CP.Cd_Tipo_Servico='B'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal = 'IO'
					and CPT.Cd_Tp_Tx not in ('EEL','ECO')
					--and TT.Nome_Tp_Tx  not in ('Emissão de LI','Certificado de Origem')
					
	UNION ALL						
			--Tarifas Gerais por Modal			
						
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					cd_consig_hio,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Out CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
					Join House_Imp_Out hou on hou.num_proc_hio=@num_proc 						
					Join LLP_Imp_Out LLP  on num_proC_lio=@num_proc				
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hio is null
					and CP.Cd_Tipo_Servico='A'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IO'

		UNION ALL

			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					(CASE 
							When (Peso_Bruto_HIO/1000) > Vol_Tot_HIO then
								(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
									(PEso_Bruto_HIO/1000)*CPT.Vlr_Venda
								Else
									(case when(Peso_Bruto_HIO/1000)*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
											(case when (PEso_Bruto_HIO/1000)*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
												(Peso_Bruto_HIO/1000)*CPT.Vlr_Venda 
											else
												CPT.Vlr_Max_Venda 
											end)								
									else
										CPT.Vlr_Min_Venda 
									end)
								End)
						ELSE
								(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
									Vol_Tot_HIO*CPT.Vlr_Venda 
								Else
										(case when Vol_Tot_HIO*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
												(case when Vol_Tot_HIO*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
													Vol_Tot_HIO*CPT.Vlr_Venda 
												else
													CPT.Vlr_Max_Venda 
												end)
										else
											CPT.Vlr_Min_Venda 
										end)
								End)
						END)
					,convert(varchar(10),getdatE(),103),cd_consig_hio,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join Cta_Cte_Hou_Imp_Out CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
						Join House_Imp_Out hou on hou.num_proc_hio=@num_proc 						
						Join LLP_Imp_Out LLP  on num_proC_lio=@num_proc	
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='K'
						and cta.num_proc_hio is null
						and CP.Cd_Tipo_Servico='A'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='IO'
			End

	--BUSCA EXATA - ORIGEM + DESTINO + IMPORTADOR

		Begin
		Insert Cta_Cte_Hou_Imp_Out				
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hio,					 
					'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Out CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
					Join House_Imp_Out hou on hou.num_proc_hio=@num_proc and cd_consig_hio=cd_cliente
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hio is null
					and CP.Cd_Tipo_Servico='A'
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IO'					
	End

	--BUSCA EXATA + DESTINO + IMPORTADOR
	
		Begin						
		Insert Cta_Cte_Hou_Imp_Out
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hio,
					'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
			From 
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Out  CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
					Join House_Imp_Out  hou on hou.num_proc_hio=@num_proc and cd_consig_hio=cd_cliente
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hio is null
					and CP.Cd_Tipo_Servico='A'		
					AND (CD_ORG IS NULL OR CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IO'
	End

	--BUSCA POR GRUPO E DESTINO	
	
		Begin
										
		Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
		
		Insert Cta_Cte_Hou_Imp_Out
	
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hio,
					'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
			from 
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join cta_cte_hou_imp_out  CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
					Join House_imp_out hou on hou.num_proc_hio=@num_proc and cd_dst=cd_dst_hio

			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hio is null
					and CP.Cd_Tipo_Servico='A'		
					AND CD_CLIENTE=@Grupo
					AND (CD_ORG IS NULL OR CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IO'				
			
		Insert Cta_Cte_Hou_Imp_Out							
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,
				CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
				cd_consig_hio,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
				Join House_Imp_Out hou on hou.num_proc_hio=@num_proc 						
				Join LLP_Imp_Out LLP  on num_proc_lio=@num_proc
				Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 				
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hio is null
				and CP.Cd_Tipo_Servico='B'		
				AND CD_CLIENTE=@Grupo
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
				and Modal='IO'	
				and CPT.Cd_Tp_Tx = 'SR2'
			group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hio,IVA			
			
		Insert Cta_Cte_Hou_Imp_Out							
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,
				CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
				cd_consig_hio,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
				Join House_Imp_Out hou on hou.num_proc_hio=@num_proc 						
				Join LLP_Imp_Out LLP  on num_proc_lio=@num_proc
				Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 				
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hio is null
				and CP.Cd_Tipo_Servico='B'		
				AND CD_CLIENTE=@Grupo
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
				and Modal='IO'	
			and CPT.Cd_Tp_Tx = 'SRV'
			group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_hio,IVA
		
		Insert Cta_Cte_Hou_Imp_Out							
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,
				CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
				cd_consig_hio,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
				Join House_Imp_Out hou on hou.num_proc_hio=@num_proc 						
				Join LLP_Imp_Out LLP  on num_proc_lio=@num_proc				
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hio is null
				and CP.Cd_Tipo_Servico='B'		
				AND CD_CLIENTE=@Grupo
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
				and Modal='IO'	
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
				
		UNION ALL
									
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,
				CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
				cd_consig_hio,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Out CTA on cta.num_proc_hio=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hio='C'		
				Join House_Imp_Out hou on hou.num_proc_hio=@num_proc 						
				Join LLP_Imp_Out LLP  on num_proC_lio=@num_proc				
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hio is null
				and CP.Cd_Tipo_Servico='C'		
				AND CD_CLIENTE=@Grupo
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
				and Modal='IO'
			
	END

END
*/
GO
