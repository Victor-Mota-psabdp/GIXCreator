SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Ajuste_REF_CSR]

as

Declare @Num_Proc varchar(16)
Declare @Num_Pedido varchar(80)
Declare @Dt_Pedido datetime
Declare @Cd_Usuario varchar(10)
Declare @ID int
Declare Cur_TABJOB cursor for
	select Num_Proc from Pedido_Ship with(nolock)
	where Dt_ins >= GETDATE() -1 and Num_Proc like 'E%CSR%' group by Num_Proc
	--where Dt_ins >= '2016-01-01' and SUBSTRING(Num_Proc,1,5) = 'EMCSR' group by Num_Proc
	--where Dt_ins >= '2016-01-01' and Num_Proc = 'EOCSR201610015BR' group by Num_Proc	
		Open Cur_TABJOB
			Fetch Next From Cur_TABJOB Into @Num_Proc
				While @@FETCH_STATUS = 0
			
				BEGIN						
					If LEFT(@Num_Proc,2) = 'EM'
						BEGIN	
							--Sales Order
							Declare Cur_TAB8 cursor for
								select Num_Pedido,P.Dt_Pedido,cd_usuario from Pedido_Ship PS with(nolock)
								join Pedido P with(nolock) on PS.cd_pedido = P.cd_pedido 
								where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEM from po_HEM with(nolock) where 
								Num_Proc_HEM=@Num_Proc and ID_DC = '3')
							Open Cur_TAB8
								Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido,@Cd_Usuario								
								While @@FETCH_STATUS = 0
									Begin	
										SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc)	
										INSERT INTO
													PO_HEM
													(Num_Proc_HEM,ID_PO_HEM,Numero_PO_HEM,Data_PO_HEM,Id_DC,cd_usuario,dt_ins)
												VALUES
													(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'3',@Cd_Usuario,GETDATE())
										Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
									end
								close Cur_TAB8
								deallocate Cur_TAB8
										
							--Shipment Number
							Declare Cur_TAB8 cursor for							
								select Num_Pedido,P.Dt_Pedido,cd_usuario from Pedido_Ship PS
								join Pedido P on PS.cd_pedido = P.cd_pedido 
								where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEM from po_HEM where 
								Num_Proc_HEM=@Num_Proc and ID_DC = '8')
							Open Cur_TAB8
								Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido,@Cd_Usuario								
								While @@FETCH_STATUS = 0
									Begin	
										SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc)	
										INSERT INTO
													PO_HEM
													(Num_Proc_HEM,ID_PO_HEM,Numero_PO_HEM,Data_PO_HEM,Id_DC,cd_usuario,dt_ins)
												VALUES
													(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'8',@Cd_Usuario,GETDATE())
										Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
									end
								close Cur_TAB8
								deallocate Cur_TAB8
										
						END
										
					If LEFT(@Num_Proc,2) = 'EA'
						BEGIN
							--Sales Order
							Declare Cur_TAB8 cursor for
								select Num_Pedido,P.Dt_Pedido,cd_usuario from Pedido_Ship PS with(nolock)
								join Pedido P with(nolock) on PS.cd_pedido = P.cd_pedido 
								where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEA from po_HEA with(nolock) where 
								Num_Proc_HEA=@Num_Proc and ID_DC = '3')
							Open Cur_TAB8
								Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido,@Cd_Usuario
					
								While @@FETCH_STATUS = 0
									Begin	
										SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc)	
										INSERT INTO
													PO_HEA
													(Num_Proc_HEA,ID_PO_HEA,Numero_PO_HEA,Data_PO_HEA,Id_DC,cd_usuario,dt_ins)
												VALUES
													(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'3',@Cd_Usuario,GETDATE())
										Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
									end
								close Cur_TAB8
								deallocate Cur_TAB8
												
							--Shipment Number
							Declare Cur_TAB8 cursor for							
									select Num_Pedido,P.Dt_Pedido,cd_usuario from Pedido_Ship PS
									join Pedido P on PS.cd_pedido = P.cd_pedido 
									where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEA from po_HEA where 
									Num_Proc_HEA=@Num_Proc and ID_DC = '8')
								Open Cur_TAB8
									Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido,@Cd_Usuario
									
									While @@FETCH_STATUS = 0
										Begin	
											SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc)	
											INSERT INTO
														PO_HEA
														(Num_Proc_HEA,ID_PO_HEA,Numero_PO_HEA,Data_PO_HEA,Id_DC,cd_usuario,dt_ins)
													VALUES
														(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'8',@Cd_Usuario,GETDATE())
											Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
										end
									close Cur_TAB8
									deallocate Cur_TAB8
						END
											
					If LEFT(@Num_Proc,2) = 'EO'
						BEGIN
							--Sales Order
							Declare Cur_TAB8 cursor for
								select Num_Pedido,P.Dt_Pedido,cd_usuario from Pedido_Ship PS with(nolock)
								join Pedido P with(nolock) on PS.cd_pedido = P.cd_pedido 
								where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEO from po_HEO with(nolock) where 
								Num_Proc_HEO=@Num_Proc and ID_DC = '3')
							Open Cur_TAB8
								Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido,@Cd_Usuario
						
								While @@FETCH_STATUS = 0
									Begin	
										SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc)	
										INSERT INTO
													PO_HEO
													(Num_Proc_HEO,ID_PO_HEO,Numero_PO_HEO,Data_PO_HEO,Id_DC,cd_usuario,dt_ins)
												VALUES
													(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'3',@Cd_Usuario,GETDATE())
										Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
									end
								close Cur_TAB8
								deallocate Cur_TAB8
												
							--Shipment Number
							Declare Cur_TAB8 cursor for									
								select Num_Pedido,P.Dt_Pedido,cd_usuario from Pedido_Ship PS
								join Pedido P on PS.cd_pedido = P.cd_pedido 
								where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEO from PO_HEO where 
								Num_Proc_HEO=@Num_Proc and ID_DC = '8')
							Open Cur_TAB8
								Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido,@Cd_Usuario											
									While @@FETCH_STATUS = 0
										Begin	
											SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc)	
											INSERT INTO
														PO_HEO
														(Num_Proc_HEO,ID_PO_HEO,Numero_PO_HEO,Data_PO_HEO,Id_DC,cd_usuario,dt_ins)
													VALUES
														(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'8',@Cd_Usuario,GETDATE())
											Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
										end
									close Cur_TAB8
									deallocate Cur_TAB8
						END
										
				Fetch Next From Cur_TABJOB Into @Num_Proc
			END
		close Cur_TABJOB
		deallocate Cur_TABJOB
		
		
		
		




--ALTER procedure [dbo].[spATL_Ajuste_REF_CSR]

--as

--Declare @Num_Proc varchar(16)
--Declare @Num_Pedido varchar(80)
--Declare @Dt_Pedido datetime
--Declare @ID int
--Declare Cur_TABJOB cursor for
--	select Num_Proc from Pedido_Ship with(nolock)
--	where Dt_ins >= GETDATE() -1 and Num_Proc like 'E%CSR%' group by Num_Proc
--	--where Dt_ins >= '2016-01-01' and SUBSTRING(Num_Proc,1,5) = 'EMCSR' group by Num_Proc
--	--where Dt_ins >= '2016-01-01' and Num_Proc = 'EOCSR201610015BR' group by Num_Proc	
--			Open Cur_TABJOB
--				Fetch Next From Cur_TABJOB Into @Num_Proc
--					While @@FETCH_STATUS = 0
--						Begin	
--						--Sales Order
--							Declare Cur_TAB8 cursor for
--										select Num_Pedido,P.Dt_Pedido from Pedido_Ship PS with(nolock)
--										join Pedido P with(nolock) on PS.cd_pedido = P.cd_pedido 
--										where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEM from po_HEM with(nolock) where 
--										Num_Proc_HEM=@Num_Proc and ID_DC = '3')
--								Open Cur_TAB8
--									Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
									
--										While @@FETCH_STATUS = 0
--											Begin	
--												SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc)	
--												INSERT INTO
--															PO_HEM
--															(Num_Proc_HEM,ID_PO_HEM,Numero_PO_HEM,Data_PO_HEM,Id_DC)
--														VALUES
--															(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'3')
--												Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
--											end
--										close Cur_TAB8
--										deallocate Cur_TAB8
										

--							Declare Cur_TAB8 cursor for
--							--Shipment Number
--										select Num_Pedido,P.Dt_Pedido from Pedido_Ship PS
--										join Pedido P on PS.cd_pedido = P.cd_pedido 
--										where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEM from po_HEM where 
--										Num_Proc_HEM=@Num_Proc and ID_DC = '8')
--								Open Cur_TAB8
--									Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
									
--										While @@FETCH_STATUS = 0
--											Begin	
--												SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc)	
--												INSERT INTO
--															PO_HEM
--															(Num_Proc_HEM,ID_PO_HEM,Numero_PO_HEM,Data_PO_HEM,Id_DC)
--														VALUES
--															(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'8')
--												Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
--											end
--										close Cur_TAB8
--										deallocate Cur_TAB8
										
--										If LEFT(@Num_Proc,2) = 'EA'
--											Begin
--														--Sales Order
--													Declare Cur_TAB8 cursor for
--														select Num_Pedido,P.Dt_Pedido from Pedido_Ship PS with(nolock)
--														join Pedido P with(nolock) on PS.cd_pedido = P.cd_pedido 
--														where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEA from po_HEA with(nolock) where 
--														Num_Proc_HEA=@Num_Proc and ID_DC = '3')
--													Open Cur_TAB8
--													Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
											
--												While @@FETCH_STATUS = 0
--													Begin	
--														SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc)	
--														INSERT INTO
--																	PO_HEA
--																	(Num_Proc_HEA,ID_PO_HEA,Numero_PO_HEA,Data_PO_HEA,Id_DC)
--																VALUES
--																	(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'3')
--														Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
--													end
--												close Cur_TAB8
--												deallocate Cur_TAB8
												

--									Declare Cur_TAB8 cursor for
--									--Shipment Number
--												select Num_Pedido,P.Dt_Pedido from Pedido_Ship PS
--												join Pedido P on PS.cd_pedido = P.cd_pedido 
--												where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEA from po_HEA where 
--												Num_Proc_HEA=@Num_Proc and ID_DC = '8')
--										Open Cur_TAB8
--											Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
											
--												While @@FETCH_STATUS = 0
--													Begin	
--														SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc)	
--														INSERT INTO
--																	PO_HEA
--																	(Num_Proc_HEA,ID_PO_HEA,Numero_PO_HEA,Data_PO_HEA,Id_DC)
--																VALUES
--																	(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'8')
--														Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
--													end
--												close Cur_TAB8
--												deallocate Cur_TAB8
--											End
											
--											If LEFT(@Num_Proc,2) = 'EO'
--											Begin
--														--Sales Order
--													Declare Cur_TAB8 cursor for
--														select Num_Pedido,P.Dt_Pedido from Pedido_Ship PS with(nolock)
--														join Pedido P with(nolock) on PS.cd_pedido = P.cd_pedido 
--														where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEO from po_HEO with(nolock) where 
--														Num_Proc_HEO=@Num_Proc and ID_DC = '3')
--													Open Cur_TAB8
--													Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
											
--												While @@FETCH_STATUS = 0
--													Begin	
--														SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc)	
--														INSERT INTO
--																	PO_HEO
--																	(Num_Proc_HEO,ID_PO_HEO,Numero_PO_HEO,Data_PO_HEO,Id_DC)
--																VALUES
--																	(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'3')
--														Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
--													end
--												close Cur_TAB8
--												deallocate Cur_TAB8
												

--									Declare Cur_TAB8 cursor for
--									--Shipment Number
--												select Num_Pedido,P.Dt_Pedido from Pedido_Ship PS
--												join Pedido P on PS.cd_pedido = P.cd_pedido 
--												where Num_Proc = @Num_Proc and Num_Pedido not in (select Numero_PO_HEO from PO_HEO where 
--												Num_Proc_HEO=@Num_Proc and ID_DC = '8')
--										Open Cur_TAB8
--											Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
											
--												While @@FETCH_STATUS = 0
--													Begin	
--														SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc)	
--														INSERT INTO
--																	PO_HEO
--																	(Num_Proc_HEO,ID_PO_HEO,Numero_PO_HEO,Data_PO_HEO,Id_DC)
--																VALUES
--																	(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'8')
--														Fetch Next From Cur_TAB8 Into @Num_Pedido,@Dt_Pedido
--													end
--												close Cur_TAB8
--												deallocate Cur_TAB8
--											End
										
--		Fetch Next From Cur_TABJOB Into @Num_Proc
--	end
--close Cur_TABJOB
--deallocate Cur_TABJOB
GO
