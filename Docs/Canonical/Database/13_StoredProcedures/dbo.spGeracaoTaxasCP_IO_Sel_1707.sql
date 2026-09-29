SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[spGeracaoTaxasCP_IO_Sel_1707]
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
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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

		Insert CtA_cte_hou_imp_out			
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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
					
union all						
			--Tarifas Gerais por Modal							
						
			Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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

			Begin
				--BUSCA EXATA - ORIGEM + DESTINO + IMPORTADOR
				Insert Cta_Cte_Hou_Imp_Out
				
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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

			BEGIN		
				--BUSCA EXATA + DESTINO + IMPORTADOR
			
				Insert Cta_Cte_Hou_Imp_Out 
		
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
						Cd_Tp_Moeda_Venda,CPT.Vlr_Venda,convert(varchar(10),getdatE(),103),cd_consig_hio,
						'N','N','N','N','N','N',null,null,null,null,null,0,0,0,0,0,null,0,0
				from 
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


			BEGIN
				--BUSCA POR GRUPO E DESTINO
				
				Set @Grupo=(select cd_pes_Grupo from grupo where grupo=substring(@num_proc,3,3))	
				
				Insert Cta_Cte_Hou_Imp_Out
		
				Select 
						@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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
				
				
			insert Cta_Cte_Hou_Imp_Out							
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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
			
				
			insert Cta_Cte_Hou_Imp_Out							
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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
			
			insert Cta_Cte_Hou_Imp_Out							
				Select 
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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
					@Num_Proc,CPT.cd_Tp_Tx,'C','ATL',convert(varchar(10),getdatE(),103),
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

GO
