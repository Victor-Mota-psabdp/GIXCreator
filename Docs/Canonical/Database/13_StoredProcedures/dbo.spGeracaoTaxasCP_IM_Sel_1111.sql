SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spGeracaoTaxasCP_IM_Sel_1111] --'IMFMC201408049BR'
			@Num_Proc	Varchar(16)
AS
	Declare @Grupo	Varchar(10)

Begin /**Cria Por Cliente**/
	Begin /**Origem ALL**/
insert Cta_Cte_Hou_Imp_Mar
		Select 
			@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
			Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
			'N',	
				case IVA
					when 'N' then 'S'
					else 'N'
				end
			,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		from 
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.num_proc_him=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
				Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@Num_Proc and  cd_consig_him=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIM
				Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
		Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_him is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
		and Modal='IM'		
union all	

		--Inspeção de Madeira
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,sum(CPT.Vlr_Venda),convert(varchar(10),getdatE(),103),cd_consig_him,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
					Customer_Profile_Taxas CPT with(nolock)
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.num_proc_him=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
					Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@Num_Proc and  cd_consig_him=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIM
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Container_Hou_Imp_Mar CH with(nolock) on LLP.Num_Proc_Lim = CH.Num_Proc_HIM
					join Container_Mas_Imp_Mar CM with(nolock) on CH.Num_Proc_MIM = CM.Num_Proc_MIM and CH.Item_Cont_IM = CM.Item_Cont_IM and CM.Inspecao='S'
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='C'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='B'
					AND (CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and CPT.cd_tp_tx = 'ATI'
			and Modal='IM'
			group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,cd_consig_him,IVA		
				
		union all
			--Emissão de LI
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_him,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
						Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 		and  cd_consig_him=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIM				
						Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc 
						Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI <> 4
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_him is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IM'
						and CPT.Cd_Tp_Tx = 'EEL'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
union all
			--LI SUB
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_him,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
						Join House_Imp_Mar hou with(nolock)  on hou.num_proc_him=@num_proc 		and  cd_consig_him=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIM				
						Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc 
						Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI = 4
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_him is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IM'
						and CPT.Cd_Tp_Tx = 'SUB'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
union all
				--Certificado de Origem
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HIM),convert(varchar(10),getdatE(),103),cd_consig_him,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
						Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 	and  cd_consig_him=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIM					
						Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
						Join PO_HIM P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HIM = @Num_Proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_him is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IM'
						and CPT.Cd_Tp_Tx = 'ECO'
						--and TT.Nome_Tp_Tx = 'Certificado de Origem'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
union All
 --Documento
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
						Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc and  cd_consig_him=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HIM			
						Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx						
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_him is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IM'
						and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')

	End /**Origem ALL**/
	Begin /**Origem and Destino ALL**/
	insert Cta_Cte_Hou_Imp_Mar
		Select 
			@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
			Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
			'N',	
				case IVA
					when 'N' then 'S'
					else 'N'
				end
			,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		from 
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.num_proc_him=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
				Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@Num_Proc and  cd_consig_him=cd_cliente
				Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
		Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_him is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
		and Modal='IM'		
union all	

		--Inspeção de Madeira
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,sum(CPT.Vlr_Venda),convert(varchar(10),getdatE(),103),cd_consig_him,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
					Customer_Profile_Taxas CPT with(nolock)
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.num_proc_him=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
					Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@Num_Proc and  cd_consig_him=cd_cliente
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Container_Hou_Imp_Mar CH with(nolock) on LLP.Num_Proc_Lim = CH.Num_Proc_HIM
					join Container_Mas_Imp_Mar CM with(nolock) on CH.Num_Proc_MIM = CM.Num_Proc_MIM and CH.Item_Cont_IM = CM.Item_Cont_IM and CM.Inspecao='S'
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='C'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='B'
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and CPT.cd_tp_tx = 'ATI'
			and Modal='IM'	
			group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,cd_consig_him,IVA	
				
		union all
			--Emissão de LI
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_him,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
						Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 		and  cd_consig_him=cd_cliente				
						Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc 
						Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI <> 4
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_him is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IM'
						and CPT.Cd_Tp_Tx = 'EEL'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
union all
			--LI SUB
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_him,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
						Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 		and  cd_consig_him=cd_cliente				
						Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc 
						Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null)  and Num_LI is not null and ID_Tipo_LI = 4
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_him is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IM'
						and CPT.Cd_Tp_Tx = 'SUB'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
union all
				--Certificado de Origem
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HIM),convert(varchar(10),getdatE(),103),cd_consig_him,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
						Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 	and  cd_consig_him=cd_cliente					
						Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
						Join PO_HIM P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HIM = @Num_Proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_him is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IM'
						and CPT.Cd_Tp_Tx = 'ECO'
						--and TT.Nome_Tp_Tx = 'Certificado de Origem'
				group by CPT.cd_Tp_Tx,
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
union All

				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
						Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 			and  cd_consig_him=cd_cliente			
						Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx						
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_him is null
						and CP.Cd_Tipo_Servico='B'		
						--AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'IM'
						and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')

	End /**Origem and Destino ALL**/
End /**Cria Por Cliente**/

Begin /**Cria Por Grupo*/
	Begin /**Origem  ALL**/
insert Cta_Cte_Hou_Imp_Mar
		--Select 
		--	@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
		--	Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
		--	'N',	
		--		case IVA
		--			when 'N' then 'S'
		--			else 'N'
		--		end
		--	,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		--from 
		--		Customer_Profile_Taxas CPT
		--		Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
		--		Left Join Cta_Cte_Hou_Imp_Mar CTA on cta.num_proc_him=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
		--		Join House_Imp_Mar hou on hou.num_proc_him=@Num_Proc 
		--		Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
		--		join Pessoa_LLP PL on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
		--Where
		--		id_status_cp='1'
		--		And Cd_Tipo_Venda='J'
		--		and cta.num_proc_him is null
		--		and CP.Cd_Tipo_Servico='B'
		--		AND (cd_DST='ALL' and CD_ORG='ALL')
		--		and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
		--and Modal='IM'	
			
--union all	
		--Inspeção de Madeira
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,sum(CPT.Vlr_Venda),convert(varchar(10),getdatE(),103),cd_consig_him,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
					Customer_Profile_Taxas CPT with(nolock)
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.num_proc_him=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
					Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@Num_Proc and CP.Cd_Dst = HOU.Cd_Dst_HIM 
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Container_Hou_Imp_Mar CH with(nolock) on LLP.Num_Proc_Lim = CH.Num_Proc_HIM
					join Container_Mas_Imp_Mar CM with(nolock) on CH.Num_Proc_MIM = CM.Num_Proc_MIM and CH.Item_Cont_IM = CM.Item_Cont_IM and CM.Inspecao='S'
					join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='C'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='B'
					AND (CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and CPT.cd_tp_tx = 'ATI'
			and Modal='IM'
			group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,cd_consig_him,IVA
				
		union all
	--Emissão de LI
		Select 
			 @Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
			Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_him,
			'N',	
				case IVA
					when 'N' then 'S'
					else 'N'
				end
			,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		From
			Customer_Profile_Taxas CPT
			Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
			Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
			Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 	and CP.Cd_Dst = HOU.Cd_Dst_HIM					
			Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
			Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI <> 4
			join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
		Where
			id_status_cp='1'
			And Cd_Tipo_Venda='D'
			and cta.num_proc_him is null
			and CP.Cd_Tipo_Servico='B'		
			--AND CD_CLIENTE=@Grupo
			AND (CD_ORG='ALL')
			and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
			and Modal = 'IM'
			and CPT.Cd_Tp_Tx = 'EEL'
		group by CPT.cd_Tp_Tx,
			Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
	union all
	--LI SUB
		Select 
				 @Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_him,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
				Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HIM						
				Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
				Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI = 4
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
				--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
		Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_him is null
				and CP.Cd_Tipo_Servico='B'		
				--AND CD_CLIENTE=@Grupo
				AND (CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IM'
				and CPT.Cd_Tp_Tx = 'SUB'
		group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA	
		
		union all		
		
	--	Certificado de Origem
		Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HIM),convert(varchar(10),getdatE(),103),cd_consig_him,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
				Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HIM						
				Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
				Join PO_HIM P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HIM = @Num_Proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
				--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
		Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_him is null
				and CP.Cd_Tipo_Servico='B'		
				--AND CD_CLIENTE=@Grupo
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IM'
				and CPT.Cd_Tp_Tx = 'ECO'
				--and TT.Nome_Tp_Tx = 'Certificado de Origem'
		group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
union all

		Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
				Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HIM						
				Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
				Join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
				--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx						
		Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_him is null
				and CP.Cd_Tipo_Servico='B'		
				--AND CD_CLIENTE=@Grupo
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IM'
				and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')
	union all
			--Serviços Prestados - SAMPLE
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
					'N',	
					case IVA
					when 'N' then 'S'
					else 'N'
					end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.Num_Proc_him=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIM='C'		
					Join House_Imp_Mar hou with(nolock) on hou.Num_Proc_Him=@Num_Proc and CP.Cd_Dst = HOU.Cd_Dst_HIM
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
					Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 					
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IM'							
					and CPT.Cd_Tp_Tx = 'SR2'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA

union all
			--Serviços Prestados - PO		
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
					'N',	
					case IVA
					when 'N' then 'S'
					else 'N'
					end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.Num_Proc_him=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIM='C'		
					Join House_Imp_Mar hou with(nolock) on hou.Num_Proc_Him=@Num_Proc and CP.Cd_Dst = HOU.Cd_Dst_HIM
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
					Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 					
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IM'							
					and CPT.Cd_Tp_Tx = 'SRV'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
		union all
		
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
					'N',	
					case IVA
					when 'N' then 'S'
					else 'N'
					end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.Num_Proc_him=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIM='C'		
					Join House_Imp_Mar hou with(nolock) on hou.Num_Proc_Him=@Num_Proc and CP.Cd_Dst = HOU.Cd_Dst_HIM
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IM'
					and CPT.Cd_Tp_Tx not in('SR2','SRV')
		
	End /**Origem ALL**/
	Begin /**Origem and Destino ALL**/
insert Cta_Cte_Hou_Imp_Mar
		--Select 
		--	@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
		--	Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
		--	'N',	
		--		case IVA
		--			when 'N' then 'S'
		--			else 'N'
		--		end
		--	,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		--from 
		--		Customer_Profile_Taxas CPT
		--		Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
		--		Left Join Cta_Cte_Hou_Imp_Mar CTA on cta.num_proc_him=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
		--		Join House_Imp_Mar hou on hou.num_proc_him=@Num_Proc 
		--		Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
		--		join Pessoa_LLP PL on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
		--Where
		--		id_status_cp='1'
		--		And Cd_Tipo_Venda='J'
		--		and cta.num_proc_him is null
		--		and CP.Cd_Tipo_Servico='B'
		--		AND (cd_DST='ALL' and CD_ORG='ALL')
		--		and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
		--and Modal='IM'	
			
--union all	
		--Inspeção de Madeira
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,sum(CPT.Vlr_Venda),convert(varchar(10),getdatE(),103),cd_consig_him,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
					Customer_Profile_Taxas CPT with(nolock)
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.num_proc_him=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
					Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@Num_Proc 
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Container_Hou_Imp_Mar CH with(nolock) on LLP.Num_Proc_Lim = CH.Num_Proc_HIM
					join Container_Mas_Imp_Mar CM with(nolock) on CH.Num_Proc_MIM = CM.Num_Proc_MIM and CH.Item_Cont_IM = CM.Item_Cont_IM and CM.Inspecao='S'
					join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='C'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='B'
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and CPT.cd_tp_tx = 'ATI'
			and Modal='IM'	
			group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,cd_consig_him,IVA
			
		union all
	--Emissão de LI
		Select 
			 @Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
			Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_him,
			'N',	
				case IVA
					when 'N' then 'S'
					else 'N'
				end
			,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		From
			Customer_Profile_Taxas CPT
			Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
			Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
			Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 						
			Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
			Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI <> 4
			join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
		Where
			id_status_cp='1'
			And Cd_Tipo_Venda='D'
			and cta.num_proc_him is null
			and CP.Cd_Tipo_Servico='B'		
			--AND CD_CLIENTE=@Grupo
			AND (cd_DST='ALL' and CD_ORG='ALL')
			and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
			and Modal = 'IM'
			and CPT.Cd_Tp_Tx = 'EEL'
		group by CPT.cd_Tp_Tx,
			Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
	union all
	--LI SUB
		Select 
				 @Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(SLI.Num_Solicitacao),convert(varchar(10),getdatE(),103),cd_consig_him,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
				Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 						
				Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
				Join Solicitacao_LI SLI with(nolock) on SLI.Num_Proc = @Num_Proc and (CobrancaCliente <> 1 or CobrancaCliente is null) and Num_LI is not null and ID_Tipo_LI = 4
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
				--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
		Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_him is null
				and CP.Cd_Tipo_Servico='B'		
				--AND CD_CLIENTE=@Grupo
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and CP.Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IM'
				and CPT.Cd_Tp_Tx = 'SUB'
		group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA	
		
		union all		
		
	--	Certificado de Origem
		Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HIM),convert(varchar(10),getdatE(),103),cd_consig_him,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
				Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 						
				Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
				Join PO_HIM P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HIM = @Num_Proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
				--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
		Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_him is null
				and CP.Cd_Tipo_Servico='B'		
				--AND CD_CLIENTE=@Grupo
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IM'
				and CPT.Cd_Tp_Tx = 'ECO'
				--and TT.Nome_Tp_Tx = 'Certificado de Origem'
		group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
union all

		Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join cta_cte_hou_imp_mar CTA with(nolock) on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
				Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=@num_proc 						
				Join LLP_Imp_MAr LLP  with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc
				Join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
				--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx						
		Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_him is null
				and CP.Cd_Tipo_Servico='B'		
				--AND CD_CLIENTE=@Grupo
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'IM'
				and CPT.Cd_Tp_Tx not in ('EEL','ECO','SUB')
	union all
			--Serviços Prestados - SAMPLE
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
					'N',	
					case IVA
					when 'N' then 'S'
					else 'N'
					end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.Num_Proc_him=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIM='C'		
					Join House_Imp_Mar hou with(nolock) on hou.Num_Proc_Him=@Num_Proc
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
					Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 					
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IM'							
					and CPT.Cd_Tp_Tx = 'SR2'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA

union all
			--Serviços Prestados - PO		
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
					'N',	
					case IVA
					when 'N' then 'S'
					else 'N'
					end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.Num_Proc_him=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIM='C'		
					Join House_Imp_Mar hou with(nolock) on hou.Num_Proc_Him=@Num_Proc
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
					Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 					
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IM'							
					and CPT.Cd_Tp_Tx = 'SRV'
					group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,cd_consig_him,IVA
		union all
		
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
					'N',	
					case IVA
					when 'N' then 'S'
					else 'N'
					end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.Num_Proc_him=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIM='C'		
					Join House_Imp_Mar hou with(nolock) on hou.Num_Proc_Him=@Num_Proc
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='B'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IM'
					and CPT.Cd_Tp_Tx not in('SR2','SRV')
		
	End /**Origem and Destino ALL**/
End /**Cria Por Grupo*/

Begin /**Regras Gerais**/
insert Cta_Cte_Hou_Imp_Mar
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
					'N',	
					case IVA
					when 'N' then 'S'
					else 'N'
					end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.Num_Proc_him=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIM='C'		
					Join House_Imp_Mar hou with(nolock) on hou.Num_Proc_Him=@Num_Proc
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc		
					join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente					
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='A'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IM'
Union all
						
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_him,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join Cta_Cte_Hou_Imp_Mar CTA with(nolock) on cta.Num_Proc_him=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIM='C'		
					Join House_Imp_Mar hou with(nolock) on hou.Num_Proc_Him=@Num_Proc
					Join LLP_Imp_MAr LLP with(nolock) on LLP.cd_tp_Carga=cp.tipo_carga	and num_proC_lim=@num_proc	
					join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_him is null
					and CP.Cd_Tipo_Servico='C'		
					--AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='IM'
End /**Regras Gerais**/
GO
