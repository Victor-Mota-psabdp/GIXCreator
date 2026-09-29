SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido salvar o usuario e a data

CREATE Procedure [dbo].[spAtualizaPOAll_InsUpd]

@Num_Proc	varchar(16),
@Numero_PO	Varchar(80),
@Data_PO	Datetime,
@Id_DC		int,
@cd_usuario    varchar(6)


AS
BEGIN TRANSACTION

	declare @ID	int

	if left(@Num_Proc,2)='EA'
		begin
			if exists (select * from PO_HEA where num_proc_HEA = @Num_Proc and ID_DC = @ID_DC and Numero_PO_hea=@Numero_PO)
				begin
					update
						PO_HEA
					set
						Data_PO_hea = @Data_PO,
						Numero_PO_hea = @Numero_PO,
						cd_usuario = @cd_usuario,
						dt_ins = getdate()
					where 
						num_proc_HEA = @Num_Proc and ID_DC = @ID_DC
				end
			else
				begin
					SET @ID=(select Isnull(max(id_po_hea),0)+1 from po_hea where Num_Proc_hea=@Num_Proc)
					insert into
						PO_HEA(Num_Proc_HEA,
								ID_PO_HEA,
								Numero_PO_HEA,
								DAta_PO_HEA,
								ID_DC,
								cd_usuario,
								dt_ins)
					Values(@Num_Proc,
							@ID,
							@Numero_PO,
							@Data_PO,
							@ID_DC,
							@cd_usuario,
							getdate())
				end
			end
		if left(@Num_Proc,2)='EM'
			begin
				if exists (select * from PO_HEM where num_proc_HEM = @Num_Proc and ID_DC = @ID_DC and Numero_PO_hem=@Numero_PO )
					begin
						update
							PO_HEM
						set
							Data_PO_hem = @Data_PO,
							Numero_PO_hem = @Numero_PO,
							cd_usuario = @cd_usuario,
							dt_ins = getdate()
						where 
							num_proc_HEM = @Num_Proc and ID_DC = @ID_DC
					end
				else
					begin
						SET @ID=(select Isnull(max(id_po_hem),0)+1 from po_hem where Num_Proc_hem=@Num_Proc)
						insert into
							PO_HEM(Num_Proc_HEM,
									ID_PO_HEM,
									Numero_PO_HEM,
									DAta_PO_HEM,
									ID_DC,
									cd_usuario,
									dt_ins)
						Values(@Num_Proc,
								@ID,
								@Numero_PO,
								@Data_PO,
								@ID_DC,
								@cd_usuario,
								getdate())
					end
				end
			if left(@Num_Proc,2)='EO'
				begin
					if exists (select * from PO_HEO where num_proc_HEO = @Num_Proc and ID_DC = @ID_DC and Numero_PO_heo= @Numero_PO)
						begin
							update
								PO_HEO
							set
								Data_PO_heo = @Data_PO,
								Numero_PO_heo = @Numero_PO,
								cd_usuario = @cd_usuario,
								dt_ins = getdate()
							where 
								num_proc_HEO = @Num_Proc and ID_DC = @ID_DC
						end
					else
						begin
							SET @ID=(select Isnull(max(id_po_heo),0)+1 from po_heo where Num_Proc_heo=@Num_Proc)
							insert into
								PO_HEO(Num_Proc_HEO,
										ID_PO_HEO,
										Numero_PO_HEO,
										DAta_PO_HEO,
										ID_DC,
										cd_usuario,
										dt_ins)
							Values(@Num_Proc,
									@ID,
									@Numero_PO,
									@Data_PO,
									@ID_DC,
									@cd_usuario,
									getdate())
						end
					end
				if left(@Num_Proc,2)='IM'
					begin
						if exists (select * from PO_HIM where num_proc_HIM = @Num_Proc and ID_DC = @ID_DC and Numero_PO_him = @Numero_PO)
							begin
								update
									PO_HIM
								set
									Data_PO_him = @Data_PO,
									Numero_PO_him = @Numero_PO,
									cd_usuario = @cd_usuario,
									dt_ins = getdate()
								where 
									num_proc_HIM = @Num_Proc and ID_DC = @ID_DC
							end
						else
							begin
								SET @ID=(select Isnull(max(id_po_him),0)+1 from po_him where Num_Proc_him=@Num_Proc)
								insert into
									 PO_HIM(Num_Proc_HIM,
											ID_PO_HIM,
											Numero_PO_HIM,
											DAta_PO_HIM,
											ID_DC,
											cd_usuario,
											dt_ins)
								Values(@Num_Proc,
										@ID,
										@Numero_PO,
										@Data_PO,
										@ID_DC,
										@cd_usuario,
										getdate())
							end
						end
				if left(@Num_Proc,2)='IA'
					begin
						if exists (select * from PO_HIA where num_proc_HIA = @Num_Proc and ID_DC = @ID_DC and Numero_PO_hia=@Numero_PO)
							begin
								update
									PO_HIA
								set
									Data_PO_hia = @Data_PO,
									Numero_PO_hia = @Numero_PO,
									cd_usuario = @cd_usuario,
									dt_ins = getdate()
								where 
									num_proc_HIA = @Num_Proc and ID_DC = @ID_DC
							end
						else
							begin
								SET @ID=(select Isnull(max(id_po_hia),0)+1 from po_hia where Num_Proc_hia=@Num_Proc)
								insert into
									PO_HIA(Num_Proc_HIA,
											ID_PO_HIA,
											Numero_PO_HIA,
											DAta_PO_HIA,
											ID_DC,
											cd_usuario,
											dt_ins)
								Values(@Num_Proc,
										@ID,
										@Numero_PO,
										@Data_PO,
										@ID_DC,
										@cd_usuario,
										getdate())
							end
						end
				if left(@Num_Proc,2)='IO'
					begin
						if exists (select * from PO_HIO where num_proc_HIO = @Num_Proc and ID_DC = @ID_DC and Numero_PO_hio=@Numero_PO)
							begin
								update
									PO_HIO
								set
									Data_PO_hio = @Data_PO,
									Numero_PO_hio = @Numero_PO,
									cd_usuario = @cd_usuario,
									dt_ins = getdate()
								where 
									num_proc_HIO = @Num_Proc and ID_DC = @ID_DC
							end
						else
							begin
								SET @ID=(select Isnull(max(id_po_hio),0)+1 from po_hio where Num_Proc_hio=@Num_Proc)
								insert into
									PO_HIO(Num_Proc_HIO,
											ID_PO_HIO,
											Numero_PO_HIO,
											DAta_PO_HIO,
											ID_DC,
											cd_usuario,
											dt_ins)
								Values(@Num_Proc,
										@ID,
										@Numero_PO,
										@Data_PO,
										@ID_DC,
										@cd_usuario,
										getdate())
							end
						end
						
IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	


GO
