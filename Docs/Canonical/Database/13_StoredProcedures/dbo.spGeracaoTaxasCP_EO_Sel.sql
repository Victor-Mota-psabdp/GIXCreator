SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGeracaoTaxasCP_EO_Sel] --'EOFMC201408049BR'

		@Num_Proc	Varchar(16),
		@Cd_Usuario varchar(6)

AS	

Declare @CtaCte table(
Num_Proc_HEO varchar(16),
Cd_Tp_Tx varchar(3),
DC_HEO char(1),
Org_Ins_HEO varchar(9),
Dt_Ins_HEO varchar(10),
Cd_Tp_Moeda varchar(3),
Vlr_Org_HEO decimal(10, 2),
Dt_Prev_Pgto_HEO varchar(10),
Cd_Cred_Dev_HEO varchar(10),
Desp_Org_HEO char(1),
CPMF_HEO char(1),
Comp_RP_HEO char(1),
Comp_DN_HEO char(1),
Comp_CN_HEO char(1),
Comp_CPA_HEO char(1),
Num_DCN_HEO char(1),
Dt_Ctb_CC_HEO varchar(10),
Num_NF_HEO varchar(12),
Ref_Acesso_NF_HEO char(1),
Vlr_Pgto_NF_HEO decimal(9, 2),
Par_NF_HEO float,
Comp_Job_HEO char(1),
Contab bit,
Vlr_Contab decimal(18, 0),
Contab_Ant bit,
Vlr_Contab_Ant decimal(18, 0),
Contab_Mes_Ano varchar(7),
Val_Con_Comp decimal(18, 0)
)

Begin /**Cria Por Cliente**/

	Begin /**Origem ALL**/
	
		insert @CtaCte
		
			--Tipo venda JOB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.Num_Proc_HEO=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc and Cd_Export_HEO=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HEO
				Join LLP_Imp_Out LLP with(nolock) on num_proC_lio=@num_proc
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'
				
		UNION ALL

			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HEO),convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.Num_Proc_HEO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@num_proc and Cd_Export_HEO=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HEO					
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc
				Join PO_HEO P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HEO = @Num_Proc										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EO'
				and CPT.Cd_Tp_Tx = 'ECO'				
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO,IVA
						
		UNION All

			--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.Num_Proc_HEO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@num_proc and  Cd_Export_HEO=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HEO			
				Join LLP_Exp_Out LLP  with(nolock) on Num_Proc_Leo=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'				
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EO'
				and CPT.Cd_Tp_Tx not in ('ECO')

	End /**Origem ALL**/
	
	Begin /**Origem and Destino ALL**/
	
		insert @CtaCte
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			from 
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.Num_Proc_HEO=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc and  Cd_Export_HEO=cd_cliente
				Join LLP_Exp_Out LLP with(nolock) on  Num_Proc_Leo=@num_proc	 --LLP.cd_tp_Carga=cp.tipo_carga	and
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'	

			--Inspeção de Madeira nao tem no EO
			
		UNION ALL	
			
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HEO),convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.Num_Proc_HEO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@num_proc 	and  Cd_Export_HEO=cd_cliente					
				Join LLP_Exp_Out LLP  with(nolock) on Num_Proc_Leo=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and
				Join PO_HEO P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HEO = @Num_Proc										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EO'
				and CPT.Cd_Tp_Tx = 'ECO'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO,IVA

		UNION ALL
			
			--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.Num_Proc_HEO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@num_proc and Cd_Export_HEO=cd_cliente			
				Join LLP_Exp_Out LLP  with(nolock) on  Num_Proc_Leo=@num_proc --LLP.cd_tp_Carga=cp.tipo_carga	and												
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'	
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EO'
				and CPT.Cd_Tp_Tx not in ('ECO')

	End /**Origem and Destino ALL**/
	
End /**Cria Por Cliente**/

Begin /**Cria Por Grupo*/

	Begin /**Origem  ALL**/
	
		insert @CtaCte
		
			--Inspeção de Madeira nao tem no IO
		
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HEO),convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HEO						
				Join LLP_Exp_Out LLP  with(nolock) on Num_Proc_Leo=@num_proc 
				Join PO_HEO P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HEO = @Num_Proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EO'
				and CPT.Cd_Tp_Tx = 'ECO'
			group by CPT.cd_Tp_Tx,
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO,IVA
				
		UNION ALL
			
			--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HEO						
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc
				Join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente									
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EO'					
				and CPT.Cd_Tp_Tx not in ('ECO')
				
		UNION ALL
		
			--Serviços Prestados - SAMPLE
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc and CP.Cd_Dst = HOU.Cd_Dst_HEO
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc	--LLP.cd_tp_Carga=cp.tipo_carga	and
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'							
				and CPT.Cd_Tp_Tx = 'SR2'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO,IVA

		UNION ALL
		
			--Serviços Prestados - PO		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc and CP.Cd_Dst = HOU.Cd_Dst_HEO
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'							
				and CPT.Cd_Tp_Tx = 'SRV'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO,IVA
				
		union all
		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc and CP.Cd_Dst = HOU.Cd_Dst_HEO
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Consig_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
		
	End /**Origem ALL**/
	
	Begin /**Origem and Destino ALL**/
	
		insert @CtaCte
			
			--Inspeção de Madeira nao tem no IO
				
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_HEO),convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.Num_Proc_HEO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@num_proc 						
				Join LLP_Exp_Out LLP  with(nolock) on Num_Proc_Leo=@num_proc
				Join PO_HEO P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HEO = @Num_Proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EO'
				and CPT.Cd_Tp_Tx = 'ECO'	
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO,IVA

		UNION ALL
			
			--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
		From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@num_proc 						
				Join LLP_Exp_Out LLP  with(nolock) on Num_Proc_Leo=@num_proc
				Join Grupo GP with(nolock) on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente				
		Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EO'
				and CPT.Cd_Tp_Tx not in ('ECO')
				
		UNION ALL
		
			--Serviços Prestados - SAMPLE
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'							
				and CPT.Cd_Tp_Tx = 'SR2'
			group by
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO,IVA

		UNION ALL
		
			--Serviços Prestados - PO		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc 
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente		
				Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'		
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'							
				and CPT.Cd_Tp_Tx = 'SRV'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO,IVA
				
		UNION ALL
			
			--		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc	 --LLP.cd_tp_Carga=cp.tipo_carga	and 
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='B'		
				--AND CD_CLIENTE=@Grupo
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
		
	End /**Origem and Destino ALL**/
	
End /**Cria Por Grupo*/

Begin /**Regras Gerais**/

	insert @CtaCte
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente					
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='A'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'
				
		UNION ALL
			
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,
				(CASE 
						When (Peso_Bruto_HEO/1000) > Vol_Tot_HEO then
							(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
								(Peso_Bruto_HEO/1000)*CPT.Vlr_Venda
							Else
								(case when(Peso_Bruto_HEO/1000)*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
										(case when (PEso_Bruto_HEO/1000)*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
											(Peso_Bruto_HEO/1000)*CPT.Vlr_Venda 
										else
											CPT.Vlr_Max_Venda 
										end)								
								else
									CPT.Vlr_Min_Venda 
								end)
							End)
					ELSE
							(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
								Vol_Tot_HEO*CPT.Vlr_Venda 
							Else
									(case when Vol_Tot_HEO*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
											(case when Vol_Tot_HEO*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
												Vol_Tot_HEO*CPT.Vlr_Venda 
											else
												CPT.Vlr_Max_Venda 
											end)
									else
										CPT.Vlr_Min_Venda 
									end)
							End)
					END)
				,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente	
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='K'
				and cta.num_proc_heo is null
				and CP.Cd_Tipo_Servico='A'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'				

		UNION ALL
						
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
				Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc
				Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc
				join Pessoa_LLP PL with(nolock) on HOU.Cd_Export_HEO = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEO is null
				and CP.Cd_Tipo_Servico='C'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'
					
End /**Regras Gerais**/

delete Temp from @CtaCte Temp
Join Cta_Cte_Hou_Exp_Out CTA on Temp.Num_Proc_HEO= CTA.Num_Proc_HEO  and Temp.cd_tp_Tx=CTA.cd_tp_tx and Temp.Dc_HEO=CTA.DC_HEO

insert Cta_Cte_Hou_Exp_Out
select Num_Proc_HEO,
Cd_Tp_Tx,
DC_HEO,
Org_Ins_HEO,
Dt_Ins_HEO,
Cd_Tp_Moeda,
Vlr_Org_HEO,
Dt_Prev_Pgto_HEO,
Cd_Cred_Dev_HEO,
Desp_Org_HEO,
CPMF_HEO,
Comp_RP_HEO,
Comp_DN_HEO,
Comp_CN_HEO,
Comp_CPA_HEO,
Num_DCN_HEO,
Dt_Ctb_CC_HEO,
Num_NF_HEO,
Ref_Acesso_NF_HEO,
Vlr_Pgto_NF_HEO,
Par_NF_HEO,
Comp_Job_HEO,
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
Num_Proc_HEO,
Cd_Tp_Tx,
DC_HEO,
Org_Ins_HEO,
Dt_Ins_HEO,
Cd_Tp_Moeda,
Vlr_Org_HEO,
Dt_Prev_Pgto_HEO,
Cd_Cred_Dev_HEO,
Desp_Org_HEO,
CPMF_HEO,
Comp_RP_HEO,
Comp_DN_HEO,
Comp_CN_HEO,
Comp_CPA_HEO,
Contab,
Vlr_Contab,
Contab_Ant,
Contab_Mes_Ano from @CtaCte


/*
ALTER Procedure [dbo].[spGeracaoTaxasCP_EO_Sel]

@Num_Proc	Varchar(16),
@Cd_Usuario varchar(6)
AS

Declare @CtaCte table(
Num_Proc_HEO varchar(16),
Cd_Tp_Tx varchar(3),
DC_HEO char(1),
Org_Ins_HEO varchar(9),
Dt_Ins_HEO varchar(10),
Cd_Tp_Moeda varchar(3),
Vlr_Org_HEO decimal(10, 2),
Dt_Prev_Pgto_HEO varchar(10),
Cd_Cred_Dev_HEO varchar(10),
Desp_Org_HEO char(1),
CPMF_HEO char(1),
Comp_RP_HEO char(1),
Comp_DN_HEO char(1),
Comp_CN_HEO char(1),
Comp_CPA_HEO char(1),
Num_DCN_HEO char(1),
Dt_Ctb_CC_HEO varchar(10),
Num_NF_HEO varchar(12),
Ref_Acesso_NF_HEO char(1),
Vlr_Pgto_NF_HEO decimal(9, 2),
Par_NF_HEO float,
Comp_Job_HEO char(1),
Contab bit,
Vlr_Contab decimal(18, 0),
Contab_Ant bit,
Vlr_Contab_Ant decimal(18, 0),
Contab_Mes_Ano varchar(7),
Val_Con_Comp decimal(18, 0)
)


Declare @Grupo	Varchar(10)
Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))

if upper(left(@num_proc,2))='EO'
	BEGIN
	
	--Calculo por Certificado de Origem

		--Cadu - Calculo por Certificado de Origem
		Declare @CO int			
		set @CO =(select COUNT(ID_PO_HEO) from PO_heo where ID_DC = '13' and Num_Proc_heo = @Num_Proc)			
		If @CO >0
			begin
				Insert @CtaCte							
					Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda*@CO,convert(varchar(10),getdatE(),103),
					Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
					From
							Customer_Profile_Taxas CPT with(nolock)
							Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
							Left Join @CtaCte CTA on cta.num_proc_heo=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
							Join House_exp_out hou with(nolock) on hou.num_proc_heo=@num_proc 						
							Join LLP_exp_out LLP with(nolock)  on LLP.num_proC_leo=@num_proc
							--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx				
					Where
							id_status_cp='1'
							And Cd_Tipo_Venda='D'
							and cta.num_proc_heo is null
							and CP.Cd_Tipo_Servico='B'		
							AND CD_CLIENTE=@Grupo
							AND (cd_DST='ALL' and CD_ORG='ALL')
							and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
							and Modal = 'EO'
							and CPT.Cd_Tp_Tx = 'ECO'
							--and TT.Nome_Tp_Tx = 'Certificado de Origem'
			end	
	

	--Documento
		Begin
			Insert @CtaCte	
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA  on cta.num_proc_heo=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
						Join House_Exp_Out hou with(nolock) on hou.num_proc_heo=@num_proc 						
						Join LLP_exp_out LLP with(nolock)  on LLP.num_proC_leo=@num_proc
						--Join Tipo_Taxa TT on CPT.cd_Tp_Tx = TT.Cd_Tp_Tx						
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='D'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='B'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal = 'EO'
						and CPT.Cd_Tp_Tx not in ('EEL','ECO')
						--and TT.Nome_Tp_Tx  not in ('Emissão de LI','Certificado de Origem')
					
		UNION ALL
		--Tarifas Gerais por Modal				
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,
						CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
						Cd_Export_HEO,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA on cta.num_proc_heo=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out hou with(nolock) on hou.num_proc_heo=@num_proc 						
						Join LLP_Exp_Out LLP with(nolock)  on num_proC_leo=@num_proc				
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='A'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'

			UNION ALL

				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					(CASE 
							When (Peso_Bruto_HEO/1000) > Vol_Tot_HEO then
								(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
									(PEso_Bruto_HEO/1000)*CPT.Vlr_Venda
								Else
									(case when(Peso_Bruto_HEO/1000)*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
											(case when (PEso_Bruto_HEO/1000)*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
												(Peso_Bruto_HEO/1000)*CPT.Vlr_Venda 
											else
												CPT.Vlr_Max_Venda 
											end)								
									else
										CPT.Vlr_Min_Venda 
									end)
								End)
						ELSE
								(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
									Vol_Tot_HEO*CPT.Vlr_Venda 
								Else
										(case when Vol_Tot_HEO*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
												(case when Vol_Tot_HEO*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
													Vol_Tot_HEO*CPT.Vlr_Venda 
												else
													CPT.Vlr_Max_Venda 
												end)
										else
											CPT.Vlr_Min_Venda 
										end)
								End)
						END)
					,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
				From
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA  on cta.num_proc_heo=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out hou with(nolock) on hou.num_proc_heo=@num_proc 						
						Join LLP_Exp_Out LLP with(nolock)  on num_proC_leo=@num_proc	
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='K'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='A'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'
			UNION all
			
			--cadu - /**Origem and Destino ALL**/ Tipo=B, Tipo venda=J		
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				from 
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
						Join House_Exp_Out hou with(nolock) on hou.num_proc_heo=@Num_Proc and  Cd_Export_HEO=cd_cliente
						Join LLP_Exp_Out LLP with(nolock) on Num_Proc_Leo=@num_proc	
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.Num_Proc_HEO is null
						and CP.Cd_Tipo_Servico='B'
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EO'
		End

	--BUSCA EXATA - ORIGEM + DESTINO + IMPORTADOR
		Begin
			Insert @CtaCte
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,					 
						'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				from 
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA on cta.num_proc_heo=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out hou with(nolock) on hou.num_proc_heo=@num_proc and Cd_Export_HEO=cd_cliente
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='A'
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'	
		End

	--BUSCA EXATA + DESTINO + IMPORTADOR
		Begin
			Insert @CtaCte 		
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
						'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
				from 
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte  CTA on cta.num_proc_heo=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out  hou with(nolock) on hou.num_proc_heo=@num_proc and Cd_Export_HEO=cd_cliente
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='A'		
						AND (CD_ORG IS NULL OR CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'
		End


	--BUSCA POR GRUPO E DESTINO
		Begin
			Set @Grupo=(select cd_pes_Grupo from grupo with(nolock) where grupo=substring(@num_proc,3,3))	
			
			Insert @CtaCte
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA on cta.Num_Proc_HEO=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEO='C'		
						Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=@Num_Proc								
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='A'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'
		
			Insert @CtaCte
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA on cta.num_proc_heo=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out hou with(nolock) on hou.num_proc_heo=@Num_Proc	
						Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
						join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
						join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 								
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='B'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'
						and CPT.Cd_Tp_Tx = 'SR2'
						group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO, IVA
						
			Insert @CtaCte
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA on cta.num_proc_heo=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out hou with(nolock) on hou.num_proc_heo=@Num_Proc	
						Join Pedido_Ship PS with(nolock) on  @num_proc= PS.Num_Proc
						join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
						join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 								
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='B'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'
						and CPT.Cd_Tp_Tx = 'SRV'
						group by CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEO, IVA

			Insert @CtaCte
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA on cta.num_proc_heo=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out hou with(nolock) on hou.num_proc_heo=@Num_Proc									
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='B'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'
						and CPT.Cd_Tp_Tx not in('SR2','SRV')
			Union all
			
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEO,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0 
				From
						Customer_Profile_Taxas CPT with(nolock)
						Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA on cta.num_proc_heo=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_heo='C'		
						Join House_Exp_Out hou with(nolock) on hou.num_proc_heo=@Num_Proc								
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_heo is null
						and CP.Cd_Tipo_Servico='C'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EO'
							
		End
	
	END

delete Temp from @CtaCte Temp
Join Cta_Cte_Hou_Exp_Out CTA on Temp.Num_Proc_HEO= CTA.Num_Proc_HEO  and Temp.cd_tp_Tx=CTA.cd_tp_tx and Temp.Dc_heo=CTA.DC_HEO

insert Cta_Cte_Hou_Exp_Out
select Num_Proc_HEO,
Cd_Tp_Tx,
DC_HEO,
Org_Ins_HEO,
Dt_Ins_HEO,
Cd_Tp_Moeda,
Vlr_Org_HEO,
Dt_Prev_Pgto_HEO,
Cd_Cred_Dev_HEO,
Desp_Org_HEO,
CPMF_HEO,
Comp_RP_HEO,
Comp_DN_HEO,
Comp_CN_HEO,
Comp_CPA_HEO,
Num_DCN_HEO,
Dt_Ctb_CC_HEO,
Num_NF_HEO,
Ref_Acesso_NF_HEO,
Vlr_Pgto_NF_HEO,
Par_NF_HEO,
Comp_Job_HEO,
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
Num_Proc_HEO,
Cd_Tp_Tx,
DC_HEO,
Org_Ins_HEO,
Dt_Ins_HEO,
Cd_Tp_Moeda,
Vlr_Org_HEO,
Dt_Prev_Pgto_HEO,
Cd_Cred_Dev_HEO,
Desp_Org_HEO,
CPMF_HEO,
Comp_RP_HEO,
Comp_DN_HEO,
Comp_CN_HEO,
Comp_CPA_HEO,
Contab,
Vlr_Contab,
Contab_Ant,
Contab_Mes_Ano from @CtaCte
*/
GO
