SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--cadu - alterado dia 23/12/2016
CREATE Procedure [dbo].[spGeracaoTaxasCP_EA_Sel] --'EAAMZ201612002BR','els'

	@Num_Proc	Varchar(16),
	@Cd_Usuario varchar(6)

AS

Declare @Grupo	Varchar(10)

		Declare @CtaCte table (
			Num_Proc_HEA	varchar(16),
			Cd_Tp_Tx	varchar(3),
			DC_HEA	char(1),
			Org_Ins_HEA	varchar(9),
			Dt_Ins_HEA	varchar(10),
			Cd_Tp_Moeda	varchar(3),
			Vlr_Org_HEA	decimal(10, 2),
			Dt_Prev_Pgto_HEA	varchar(10),
			Cd_Cred_Dev_HEA	varchar(10),
			Desp_Dst_HEA	char(1),
			CPMF_HEA	char(1),
			Comp_RP_HEA	char(1),
			Comp_DN_HEA	char(1),
			Comp_CN_HEA	char(1),
			Comp_CPA_HEA	char(1),
			Num_DCN_HEA	varchar(12),
			Dt_Ctb_CC_HEA	varchar(10),
			Num_NF_HEA	int,
			Ref_Acesso_NF_HEA	char(1),
			Vlr_Pgto_NF_HEA	decimal(18, 2),
			Par_NF_HEA	float,
			Comp_HAWB_HEA	char(1),
			Comp_JOB_HEA	char(1),
			Contab	bit,
			Vlr_Contab	decimal(12, 2),
			Contab_Ant	bit,
			Vlr_Contab_Ant	decimal(12, 2),
			Contab_Mes_Ano	varchar(7),
			Val_Con_Comp	decimal(12, 2)
	)

Begin /**Cria Por Cliente**/

	Begin /**Origem ALL**/
	
		Insert @CtaCte
		
			--Tipo venda JOB			
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null				
			from 
				Customer_Profile_Taxas CPT with(nolock)
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA  on cta.Num_Proc_HEA=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and DC_HEA='C'		
				Join House_Exp_Aer hou with(nolock) on hou.Num_Proc_HEA=@Num_Proc and Cd_Export_HEA=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HEA
				Join LLP_Exp_Aer LLP with(nolock) on  Num_Proc_Lea=@num_proc
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.Num_Proc_HEA is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EA'	

		UNION ALL
		
		--Inspeção de Madeira nao tem

		--Emissão de LI								
				
		--LI SUB								
		
		--Certificado de Origem
								
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_hea),convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP with(nolock) on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou with(nolock) on hou.num_proc_hea=@num_proc and Cd_Export_HEA=cd_cliente and CP.Cd_Dst = HOU.Cd_Dst_HEA				
				Join LLP_Exp_Aer LLP with(nolock) on  Num_Proc_Lea=@num_proc
				Join PO_hea P13 with(nolock) on P13.ID_DC = '13' and P13.Num_Proc_HEA = @Num_Proc								
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EA'
				and CPT.Cd_Tp_Tx = 'ECO'				
			group by
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEA,IVA	

		UNION ALL
		
		--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@num_proc and  Cd_Export_HEA=cd_cliente	and CP.Cd_Dst = HOU.Cd_Dst_HEA		
				Join LLP_Exp_Aer LLP  on  Num_Proc_Lea=@num_proc									
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EA'
				and CPT.Cd_Tp_Tx not in ('ECO')
				
	End  /**Origem ALL**/
	
	Begin /**Origem e Destino ALL**/
	
		Insert @CtaCte
			--Tipo venda JOB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			from 
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@Num_Proc and  Cd_Export_HEA=cd_cliente
				Join LLP_Exp_Aer LLP with(nolock) on  Num_Proc_Lea=@num_proc
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EA'					
			
		UNION ALL
			--Inspeção de Madeira nao tem
			
			--Emissão de LI		
			
			--LI SUB								
			
			--Certificado de Origem								
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_hea),convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@num_proc and Cd_Export_HEA=cd_cliente			
				Join LLP_Exp_Aer LLP  on  Num_Proc_Lea=@num_proc
				Join PO_HEA P13 on P13.ID_DC = '13' and P13.num_proc_hea = @Num_Proc							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EA'
				and CPT.Cd_Tp_Tx = 'ECO'					
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEA,IVA	

		UNION ALL
		
			--Documento
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@num_proc and  Cd_Export_HEA=cd_cliente	
				Join LLP_Exp_Aer LLP  on  Num_Proc_Lea=@num_proc										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EA'
				and CPT.Cd_Tp_Tx not in ('ECO')

	End  /**Origem e Destino ALL**/
	
End /**Cria Por Cliente**/

Begin /**Cria Por Grupo*/

	Begin /**Origem ALL**/
	
		Insert	@CtaCte		
			--Inspeção de Madeira nao tem
			
			--Emissão de LI					
						
			--LI SUB
					
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_hea),convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@num_proc and CP.Cd_Dst = HOU.Cd_Dst_HEA		 						
				Join LLP_Exp_Aer LLP  on  Num_Proc_Lea=@num_proc
				Join PO_hea P13 on P13.ID_DC = '13' and P13.num_proc_hea = @Num_Proc
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente								
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EA'
				and CPT.Cd_Tp_Tx = 'ECO'				
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEA,IVA
		
		UNION ALL
		
			--Documento		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@num_proc  and CP.Cd_Dst = HOU.Cd_Dst_HEA								
				Join LLP_Exp_Aer LLP  on Num_Proc_Lea=@num_proc
				Join Grupo GP on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente								
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EA'
				and CPT.Cd_Tp_Tx not in ('ECO')				

		UNION ALL
		
			--Serviços Prestados - SAMPLE
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@Num_Proc  and CP.Cd_Dst = HOU.Cd_Dst_HEA	
				Join LLP_Exp_Aer LLP with(nolock) on  Num_Proc_Lea=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente	
				Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 						
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EA'
				and CPT.Cd_Tp_Tx = 'SR2'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEA,IVA

		UNION ALL

			--Serviços Prestados - PO	
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@Num_Proc  and CP.Cd_Dst = HOU.Cd_Dst_HEA	
				Join LLP_Exp_Aer LLP with(nolock) on  Num_Proc_Lea=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente	
				Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 						
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EA'
				and CPT.Cd_Tp_Tx = 'SRV'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEA,IVA

		UNION ALL
		
			--Tipo venda JOB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@Num_Proc  and CP.Cd_Dst = HOU.Cd_Dst_HEA	
				Join LLP_Exp_Aer LLP with(nolock) on  Num_Proc_Lea=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'	
				AND (CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EA'
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
					
	End /**OrigemALL**/
	
	Begin /**Origem e Destino ALL**/
		
		Insert	@CtaCte
		
			--Inspeção de Madeira nao tem
			--Emissão de LI		
						
			--LI SUB
				
			--Certificado de Origem
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda*COUNT(ID_PO_hea),convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@num_proc 						
				Join LLP_Exp_Aer LLP  on  Num_Proc_Lea=@num_proc
				Join PO_HEA P13 on P13.ID_DC = '13' and P13.num_proc_hea = @Num_Proc
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'	
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EA'
				and CPT.Cd_Tp_Tx = 'ECO'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEA,IVA

		UNION ALL
		
			--Documento		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@num_proc 						
				Join LLP_Exp_Aer LLP  on Num_Proc_Lea=@num_proc
				Join Grupo GP on GP.Cd_Pes_Grupo = CP.Cd_Cliente
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente										
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='D'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal = 'EA'
				and CPT.Cd_Tp_Tx not in ('ECO')				

		UNION ALL
			
			--Serviços Prestados - SAMPLE
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@Num_Proc
				Join LLP_Exp_Aer LLP with(nolock) on  Num_Proc_Lea=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente	
				Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 						
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EA'
				and CPT.Cd_Tp_Tx = 'SR2'
			group by
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEA,IVA

		UNION ALL
		
			--Serviços Prestados - PO	
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@Num_Proc
				Join LLP_Exp_Aer LLP with(nolock) on  Num_Proc_Lea=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente	
				Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
				join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
				join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 						
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'	
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EA'
				and CPT.Cd_Tp_Tx = 'SRV'
			group by 
				CPT.cd_Tp_Tx,Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,Cd_Export_HEA,IVA

		UNION ALL
			
			--Tpo Venda JOB
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@Num_Proc
				Join LLP_Exp_Aer LLP with(nolock) on  Num_Proc_Lea=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='B'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EA'
				and CPT.Cd_Tp_Tx not in('SR2','SRV')
					
	End /**Origem e Destino ALL**/
	
End /**Cria Por Grupo*/

Begin /**Regras Gerais**/

		insert @CtaCte
		
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
				case IVA
				when 'N' then 'S'
				else 'N'
				end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@Num_Proc
				Join LLP_Exp_Aer LLP with(nolock) on Num_Proc_Lea=@num_proc		
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente						
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='A'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EA'

		UNION ALL
						
			Select 
				@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
				Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
				'N',	
					case IVA
						when 'N' then 'S'
						else 'N'
					end
				,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
				Customer_Profile_Taxas CPT
				Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
				Left Join @CtaCte CTA on cta.num_proc_hea=@Num_Proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
				Join House_Exp_Aer hou on hou.num_proc_hea=@Num_Proc
				Join LLP_Exp_Aer LLP with(nolock) on Num_Proc_Lea=@num_proc	
				join Pessoa_LLP PL on HOU.Cd_Export_HEA = PL.Cd_Pes and PL.Cd_Pes_Grupo = CP.Cd_Cliente							
			Where
				id_status_cp='1'
				And Cd_Tipo_Venda='J'
				and cta.num_proc_hea is null
				and CP.Cd_Tipo_Servico='C'
				AND (cd_DST='ALL' and CD_ORG='ALL')
				and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
				and Modal='EA'
				
End /**Regras Gerais**/



delete Temp from @CtaCte Temp
Join Cta_Cte_Hou_Exp_Aer CTA on Temp.Num_Proc_HEA= CTA.Num_Proc_HEA  and Temp.cd_tp_Tx=CTA.cd_tp_tx and Temp.Dc_hea=CTA.DC_HEA

insert Cta_Cte_Hou_Exp_Aer
select Num_Proc_HEA,
Cd_Tp_Tx,
DC_HEA,
Org_Ins_HEA,
Dt_Ins_HEA,
Cd_Tp_Moeda,
Vlr_Org_HEA,
Dt_Prev_Pgto_HEA,
Cd_Cred_Dev_HEA,
Desp_Dst_HEA,
CPMF_HEA,
Comp_RP_HEA,
Comp_DN_HEA,
Comp_CN_HEA,
Comp_CPA_HEA,
Num_DCN_HEA,
Dt_Ctb_CC_HEA,
Num_NF_HEA,
Ref_Acesso_NF_HEA,
Vlr_Pgto_NF_HEA,
Par_NF_HEA,
Comp_HAWB_HEA,
Comp_JOB_HEA,
Contab,
Vlr_Contab,
Contab_Ant,
Vlr_Contab_Ant,
Contab_Mes_Ano,
Val_Con_Comp
from @CtaCte



insert Log_Cta_Cte
select 
getdate(),
@Cd_Usuario,
'I',
Num_Proc_HEA,
Cd_Tp_Tx,
DC_HEA,
Org_Ins_HEA,
Dt_Ins_HEA,
Cd_Tp_Moeda,
Vlr_Org_HEA,
Dt_Prev_Pgto_HEA,
Cd_Cred_Dev_HEA,
Desp_Dst_HEA,
CPMF_HEA,
Comp_RP_HEA,
Comp_DN_HEA,
Comp_CN_HEA,
Comp_CPA_HEA,
Contab,
Vlr_Contab,
Contab_Ant,
Contab_Mes_Ano
from @CtaCte




/*
ALTER Procedure [dbo].[spGeracaoTaxasCP_EA_Sel]
			@Num_Proc	Varchar(16),
			@Cd_Usuario varchar(6)
AS

Declare @Grupo	Varchar(10)
Declare @CdPedido varchar(50)

if upper(left(@num_proc,2))='EA'
	BEGIN
			--Tarifas Gerais por Modal
						
			Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	

Declare @CtaCte table (
Num_Proc_HEA	varchar(16),
Cd_Tp_Tx	varchar(3),
DC_HEA	char(1),
Org_Ins_HEA	varchar(9),
Dt_Ins_HEA	varchar(10),
Cd_Tp_Moeda	varchar(3),
Vlr_Org_HEA	decimal(10, 2),
Dt_Prev_Pgto_HEA	varchar(10),
Cd_Cred_Dev_HEA	varchar(10),
Desp_Dst_HEA	char(1),
CPMF_HEA	char(1),
Comp_RP_HEA	char(1),
Comp_DN_HEA	char(1),
Comp_CN_HEA	char(1),
Comp_CPA_HEA	char(1),
Num_DCN_HEA	varchar(12),
Dt_Ctb_CC_HEA	varchar(10),
Num_NF_HEA	int,
Ref_Acesso_NF_HEA	char(1),
Vlr_Pgto_NF_HEA	decimal(18, 2),
Par_NF_HEA	float,
Comp_HAWB_HEA	char(1),
Comp_JOB_HEA	char(1),
Contab	bit,
Vlr_Contab	decimal(12, 2),
Contab_Ant	bit,
Vlr_Contab_Ant	decimal(12, 2),
Contab_Mes_Ano	varchar(7),
Val_Con_Comp	decimal(12, 2))



		
Insert @CtaCte			
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
			From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
					Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
					Join LLP_exp_aer LLP  on num_proC_lea=@num_proc				
			Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hea is null
					and CP.Cd_Tipo_Servico='A'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EA'

			UNION ALL

			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					(CASE 
							When (PEso_Bruto_HEA/1000) > Vol_Tot_HEA then
								(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
									(PEso_Bruto_HEA/1000)*CPT.Vlr_Venda
								Else
									(case when(PEso_Bruto_HEA/1000)*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
											(case when (PEso_Bruto_HEA/1000)*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
												(PEso_Bruto_HEA/1000)*CPT.Vlr_Venda 
											else
												CPT.Vlr_Max_Venda 
											end)								
									else
										CPT.Vlr_Min_Venda 
									end)
								End)
						ELSE
								(Case when CPT.Vlr_Min_Venda is null or CPT.Vlr_Max_Venda is null then
									Vol_Tot_HEA*CPT.Vlr_Venda 
								Else
										(case when Vol_Tot_HEA*CPT.Vlr_Venda > isnull(CPT.Vlr_Min_Venda,0) then
												(case when Vol_Tot_HEA*CPT.Vlr_Venda <  isnull(CPT.Vlr_Max_Venda,0) then
													Vol_Tot_HEA*CPT.Vlr_Venda 
												else
													CPT.Vlr_Max_Venda 
												end)
										else
											CPT.Vlr_Min_Venda 
										end)
								End)
						END)
					,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				From
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
						Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
						Join LLP_exp_aer LLP  on num_proC_lea=@num_proc	
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='K'
						and cta.num_proc_hea is null
						and CP.Cd_Tipo_Servico='A'		
						AND CD_CLIENTE=@Grupo
						AND (cd_DST='ALL' and CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EA'
						and CPT.Cd_Tp_Tx not in('SR2')
			End

			Begin
				--BUSCA EXATA - ORIGEM + DESTINO + IMPORTADOR
				Insert @CtaCte
				
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,					 
						'N','N','N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				from 
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
						Join House_exp_aer hou on hou.num_proc_hea=@num_proc and Cd_Export_HEA=cd_cliente and num_proc_mea <> 'JOB' and cd_org=cd_org_hea and cd_dst=cd_dst_hea
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_hea is null
						and CP.Cd_Tipo_Servico='A'
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EA'		
			
			End

			BEGIN		
				--BUSCA EXATA + DESTINO + IMPORTADOR
			
				Insert @CtaCte 
		
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
						'N','N','N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				from 
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte  CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
						Join House_exp_aer  hou on hou.num_proc_hea=@num_proc and Cd_Export_HEA=cd_cliente and num_proc_mea <> 'JOB' and cd_dst=cd_dst_hea
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_hea is null
						and CP.Cd_Tipo_Servico='A'		
						AND (CD_ORG IS NULL OR CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EA'
			End


			BEGIN
				--BUSCA POR GRUPO E DESTINO
				
				Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
				
				Insert @CtaCte 
		
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),Cd_Export_HEA,
						'N','N','N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				from 
						Customer_Profile_Taxas CPT
						Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
						Left Join @CtaCte  CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
						Join House_exp_aer  hou on hou.num_proc_hea=@num_proc and cd_dst=cd_dst_hea
				Where
						id_status_cp='1'
						And Cd_Tipo_Venda='J'
						and cta.num_proc_hea is null
						and CP.Cd_Tipo_Servico='A'		
						AND CD_CLIENTE=@Grupo
						AND (CD_ORG IS NULL OR CD_ORG='ALL')
						and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
						and Modal='EA'
			
			Insert @CtaCte 							
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
					Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
					Join LLP_exp_aer LLP  on num_proC_lea=@num_proc				
					Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo = '4' 
				Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hea is null
					and CP.Cd_Tipo_Servico='B'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
					and Modal='EA'	
					and CPT.Cd_Tp_Tx = 'SR2'
					group by CPT.cd_Tp_Tx,
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,
					Cd_Export_HEA,
					IVA
			union all		
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
					Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
					Join LLP_exp_aer LLP  on num_proC_lea=@num_proc				
					Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido and P.Cd_tipo <> '4' 
				Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hea is null
					and CP.Cd_Tipo_Servico='B'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
					and Modal='EA'	
					and CPT.Cd_Tp_Tx = 'SRV'
					group by CPT.cd_Tp_Tx,
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,
					Cd_Export_HEA,
					IVA
	
			Insert @CtaCte 
					Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
					Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
					Join LLP_exp_aer LLP  on num_proC_lea=@num_proc				
					Join Pedido_Ship PS on  @num_proc= PS.Num_Proc
					join Pedido_Det PDet with(nolock) on PS.cd_pedido = PDet.Cd_Pedido and PS.cd_produto =PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
					join Pedido P with(nolock) on PDet.cd_pedido = P.Cd_pedido 
				Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hea is null
					and CP.Cd_Tipo_Servico='B'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
					and Modal='EA'	
					and CPT.Cd_Tp_Tx not in('SR2','SRV')
					
			UNION ALL
										
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
					Cd_Tp_Moeda_Venda,
					CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
					Cd_Export_HEA,
					'N',	
						case IVA
							when 'N' then 'S'
							else 'N'
						end
					,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
				From
					Customer_Profile_Taxas CPT
					Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
					Left Join @CtaCte CTA on cta.num_proc_hea=@num_proc and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
					Join House_exp_aer hou on hou.num_proc_hea=@num_proc 						
					Join LLP_exp_aer LLP  on num_proC_lea=@num_proc				
				Where
					id_status_cp='1'
					And Cd_Tipo_Venda='J'
					and cta.num_proc_hea is null
					and CP.Cd_Tipo_Servico='C'		
					AND CD_CLIENTE=@Grupo
					AND (cd_DST='ALL' and CD_ORG='ALL')
					and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)	
					and Modal='EA'
				
				
			END
			
			Begin /**Origem and Destino ALL**/
				insert @CtaCte
					Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','CP',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,
						CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),
						Cd_Export_HEA,
						'N',	
							case IVA
								when 'N' then 'S'
								else 'N'
							end
						,'N','N','N','N',null,null,null,null,null,null,'N','N',0,null,0,null,null,null
						
					from 
							Customer_Profile_Taxas CPT
							Join Customer_Profile CP on CP.id_Cp=CPT.id_cp
							Left Join @CtaCte CTA on cta.Num_Proc_HEA=@Num_Proc  and CTA.cd_tp_Tx=CPT.cd_tp_tx and Dc_hea='C'		
							Join House_Exp_Aer hou on hou.Num_Proc_HEA=@Num_Proc and  Cd_Export_HEA=cd_cliente
							Join LLP_Exp_Aer LLP with(nolock) on Num_Proc_Lea=@num_proc	
					Where
							id_status_cp='1'
							And Cd_Tipo_Venda='J'
							and cta.Num_Proc_HEA is null
							and CP.Cd_Tipo_Servico='B'
							AND (cd_DST='ALL' and CD_ORG='ALL')
							and Dt_Vencimento >= convert(datetime,convert(varchar(10),getdate(),103),103)
					and Modal='EA'
				End	

delete Temp from @CtaCte Temp
Join Cta_Cte_Hou_Exp_Aer CTA on Temp.Num_Proc_HEA= CTA.Num_Proc_HEA  and Temp.cd_tp_Tx=CTA.cd_tp_tx and Temp.Dc_hea=CTA.DC_HEA

insert Cta_Cte_Hou_Exp_Aer
select Num_Proc_HEA,
Cd_Tp_Tx,
DC_HEA,
Org_Ins_HEA,
Dt_Ins_HEA,
Cd_Tp_Moeda,
Vlr_Org_HEA,
Dt_Prev_Pgto_HEA,
Cd_Cred_Dev_HEA,
Desp_Dst_HEA,
CPMF_HEA,
Comp_RP_HEA,
Comp_DN_HEA,
Comp_CN_HEA,
Comp_CPA_HEA,
Num_DCN_HEA,
Dt_Ctb_CC_HEA,
Num_NF_HEA,
Ref_Acesso_NF_HEA,
Vlr_Pgto_NF_HEA,
Par_NF_HEA,
Comp_HAWB_HEA,
Comp_JOB_HEA,
Contab,
Vlr_Contab,
Contab_Ant,
Vlr_Contab_Ant,
Contab_Mes_Ano,
Val_Con_Comp
from @CtaCte



insert Log_Cta_Cte
select 
getdate(),
@Cd_Usuario,
'I',
Num_Proc_HEA,
Cd_Tp_Tx,
DC_HEA,
Org_Ins_HEA,
Dt_Ins_HEA,
Cd_Tp_Moeda,
Vlr_Org_HEA,
Dt_Prev_Pgto_HEA,
Cd_Cred_Dev_HEA,
Desp_Dst_HEA,
CPMF_HEA,
Comp_RP_HEA,
Comp_DN_HEA,
Comp_CN_HEA,
Comp_CPA_HEA,
Contab,
Vlr_Contab,
Contab_Ant,
Contab_Mes_Ano
from @CtaCte

*/
GO
