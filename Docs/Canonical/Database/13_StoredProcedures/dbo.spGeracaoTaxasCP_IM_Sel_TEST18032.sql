SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spGeracaoTaxasCP_IM_LOG_Sel]'IMSUN201512001BR', 'Erbson'
--28/3 -incluido Origem e Destino Definido - Cadu

CREATE Procedure [dbo].[spGeracaoTaxasCP_IM_Sel_TEST18032] --'IMFMC201408049BR'
			@Num_Proc	Varchar(16),
			@Cd_Usuario varchar(6)
AS
	Declare @Grupo	Varchar(10)
	
	
Declare @CtaCte table
(
	Num_Proc_HIM varchar(16),
	Cd_Tp_Tx varchar(3),
	DC_HIM char(1),
	Org_Ins_HIM varchar(9),
	Dt_Ins_HIM varchar(10),
	Cd_Tp_Moeda varchar(3),
	Vlr_Org_HIM decimal(10, 2),
	Dt_Prev_Pgto_HIM varchar(10),
	Cd_Cred_Dev_HIM varchar(10),
	Desp_Org_HIM char(1),
	CPMF_HIM char(1),
	Comp_RP_HIM char(1),
	Comp_DN_HIM char(1),
	Comp_CN_HIM char(1),
	Comp_CPA_HIM char(1),
	Num_DCN_HIM varchar(12),
	Dt_Ctb_CC_HIM varchar(10),
	Num_NF_HIM varchar(12),
	Ref_Acesso_NF_HIM char(1),
	Vlr_Pgto_NF_HIM decimal(18, 2),
	Par_NF_HIM float,
	Comp_Job_HIM char(1),
	Contab bit,
	Vlr_Contab decimal(12, 2),
	Contab_Ant bit,
	Vlr_Contab_Ant decimal(12, 2),
	Contab_Mes_Ano varchar(7),
	Val_Con_Comp decimal(12, 2)
)

Begin /**Cria Por Cliente**/
	
	Begin /**Origem and Destino ALL**/
		insert @CtaCte
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
				Left Join @CtaCte CTA on cta.num_proc_him=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
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
					
	UNION	

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
					Left Join @CtaCte CTA on cta.num_proc_him=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
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
				
		UNION
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
						Left Join @CtaCte CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
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
		UNION
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
						Left Join @CtaCte CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
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
		UNION
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
						Left Join @CtaCte CTA  on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
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
		UNION

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
						Left Join @CtaCte CTA on cta.num_proc_him=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_him='C'		
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



Begin /**Regras Gerais**/
	insert @CtaCte
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
					Customer_Profile_Taxas CPT with(nolock)
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join @CtaCte CTA  on cta.Num_Proc_him=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIM='C'		
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
		UNION
						
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
					Customer_Profile_Taxas CPT with(nolock)
					Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
					Left Join @CtaCte CTA on cta.Num_Proc_him=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HIM='C'		
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

delete Temp from @CtaCte Temp
Join Cta_Cte_Hou_Imp_Mar CTA on Temp.Num_Proc_HIM= CTA.Num_Proc_HIM  and Temp.cd_tp_Tx=CTA.cd_tp_tx and Temp.Dc_him=CTA.DC_HIM

--insert Cta_Cte_Hou_Imp_Mar
select Num_Proc_HIM,
Cd_Tp_Tx,
DC_HIM,
Org_Ins_HIM,
Dt_Ins_HIM,
Cd_Tp_Moeda,
Vlr_Org_HIM,
Dt_Prev_Pgto_HIM,
Cd_Cred_Dev_HIM,
Desp_Org_HIM,
CPMF_HIM,
Comp_RP_HIM,
Comp_DN_HIM,
Comp_CN_HIM,
Comp_CPA_HIM,
Num_DCN_HIM,
Dt_Ctb_CC_HIM,
Num_NF_HIM,
Ref_Acesso_NF_HIM,
Vlr_Pgto_NF_HIM,
Par_NF_HIM,
Comp_Job_HIM,
Contab,
Vlr_Contab,
Contab_Ant,
Vlr_Contab_Ant,
Contab_Mes_Ano,
Val_Con_Comp from @CtaCte


--insert Log_Cta_Cte
select 
getdate(),
@Cd_Usuario,
'I',
Num_Proc_HIM,
Cd_Tp_Tx,
DC_HIM,
Org_Ins_HIM,
Dt_Ins_HIM,
Cd_Tp_Moeda,
Vlr_Org_HIM,
Dt_Prev_Pgto_HIM,
Cd_Cred_Dev_HIM,
Desp_Org_HIM,
CPMF_HIM,
Comp_RP_HIM,
Comp_DN_HIM,
Comp_CN_HIM,
Comp_CPA_HIM,
Contab,
Vlr_Contab,
Contab_Ant,
Contab_Mes_Ano from @CtaCte
GO
