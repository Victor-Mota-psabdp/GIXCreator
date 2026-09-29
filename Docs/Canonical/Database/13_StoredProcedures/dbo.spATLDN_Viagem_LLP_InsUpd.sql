SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Incluido @Terminal - 21/06/2017
--incluido veriricar se ja existe o navio x viagem x destino
--incluido o looping 17-8-2017 cadu
--sp_help Viagem_LLP

CREATE procedure [dbo].[spATLDN_Viagem_LLP_InsUpd]
(
	@ID_Viagem		int,
	@ID_Navio		int,
	@Modal			varchar(1),
	@NR_Viagem		varchar(8),
	@cd_dst			varchar(3),
	@ETD			datetime,
	@ATD			datetime,
	@ETA			datetime,
	@ATA			datetime,
	@ativo			bit,
	@id_op			int,
	@cd_usuario		Varchar(6),
	@Manifesto		varchar(11),
	@Notes			varchar(200),
	@Ano_Viagem		int,
	@Cd_Terminal	varchar(3),	
	@NID_Viagem		int output
)

AS

Declare @Num_Proc varchar(16)
Declare @Num_Proc_Master varchar(16)
Declare @cod int

set @ID_Viagem = (select id_viagem from Viagem_LLP 
					where ID_Navio = @id_navio and nr_viagem = @NR_Viagem 
					and Cd_Dst = @cd_dst and Modal = @Modal
					--And Ano_Viagem = @Ano_Viagem
					)

Begin Transaction 
	IF @ID_Viagem is null 
	   BEGIN	   
		Set @cod=(select isnull(max(id_viagem),0)+1 from Viagem_LLP)
		
		Insert 
			Viagem_LLP (id_viagem,id_navio,modal,nr_viagem,Cd_Dst,ETD,ATD,ETA,ATA,ativo,dt_ins,cd_usuario,Ano_viagem,id_op,manifesto,Notes,Id_Terminal)
		Values
						(@cod,@id_navio,@Modal,@NR_Viagem,@cd_dst,@ETD,@ATD,@ETA,@ATA,1,GETDATE(),@cd_usuario,@Ano_Viagem,@id_op,@Manifesto,@Notes,@cd_Terminal)
			Set @NID_Viagem = @cod			
	   END
	ELSE
	   BEGIN
		if exists(select id_viagem from viagem_llp where id_viagem=@ID_Viagem)
			Begin		
				Update 
					viagem_llp
				Set 
					id_navio = @id_navio,				
					nr_viagem = @NR_Viagem,
					Cd_Dst  =@cd_dst,
					ETD = @ETD,
					ATD = @ATD,
					ETA = @ETA,
					ATA = @ATA,				
					Ano_viagem = @Ano_Viagem,
					id_op = @id_op,
					manifesto = @Manifesto,
					ativo = @ativo,
					Notes = @Notes,
					Id_Terminal = @Cd_Terminal			
				Where
					ID_Viagem=@ID_Viagem
					Set @NID_Viagem = @ID_Viagem				
					
				if @Modal = 'I'
					Begin
						--LLP_Imp_Mar
						Declare cTempLLP_Imp_Mar Cursor for
						(
							select Num_Proc_Lim from LLP_Imp_Mar with(nolock) where ID_Viagem = @ID_Viagem 
						)
						open cTempLLP_Imp_Mar
							fetch next from cTempLLP_Imp_Mar into @Num_proc					
								While @@Fetch_Status=0
									Begin
										Begin
											update LLP_Imp_Mar 
												set ETA_Lim = ETA,ATA_Lim = ATA from LLP_Imp_Mar LLP
												Join viagem_llp V with(nolock) on  V.ID_Viagem = LLP.ID_Viagem
												where V.ID_Viagem = @ID_Viagem	and LLP.Num_Proc_Lim = 	@Num_proc
										End				
							fetch next from cTempLLP_Imp_Mar into @Num_proc
							End
						Close cTempLLP_Imp_Mar
						deallocate cTempLLP_Imp_Mar
						
						--LLP_Master				
						Declare cTempLLP_Master Cursor for
						(
							select Num_Proc_Master from LLP_Master with(nolock) where ID_Viagem = @ID_Viagem 
						)
						open cTempLLP_Master
						fetch next from cTempLLP_Master into @Num_Proc_Master					
							While @@Fetch_Status=0
							Begin
								Begin
									update LLP_Master						
									set ETA_Master = ETA,ATA_Master = ATA from LLP_Master LLP
									Join viagem_llp V with(nolock) on  V.ID_Viagem = LLP.ID_Viagem
									where V.ID_Viagem = @ID_Viagem and llp.Num_Proc_Master = @Num_Proc_Master 
								End				
						fetch next from cTempLLP_Master into @Num_Proc_Master
						End

						Close cTempLLP_Master
						deallocate cTempLLP_Master
					End
							
				if @Modal = 'E'	
					Begin
						--LLP_Exp_Mar
						Declare cTempLLP_Exp_Mar Cursor for
						(
							select Num_Proc_Lem from LLP_Exp_Mar with(nolock) where ID_Viagem = @ID_Viagem 
						)
						open cTempLLP_Exp_Mar
						fetch next from cTempLLP_Exp_Mar into @Num_proc
						
						While @@Fetch_Status=0
							Begin
								Begin
									update LLP_Exp_Mar						
									set ETD_Lem = ETD,ATD_Lem = ATD,Cd_Terminal = Id_Terminal								 
									from LLP_Exp_Mar LLP
									Join viagem_llp V with(nolock) on  V.ID_Viagem = LLP.ID_Viagem
									where V.ID_Viagem = @ID_Viagem and LLP.Num_Proc_Lem = @Num_Proc
								End				
								fetch next from cTempLLP_Exp_Mar into @Num_proc
							End
						Close cTempLLP_Exp_Mar
						deallocate cTempLLP_Exp_Mar
						
						--LLP_Master				
						Declare cTempLLP_Master Cursor for
						(
							select Num_Proc_Master from LLP_Master where ID_Viagem = @ID_Viagem 
						)
						open cTempLLP_Master
						fetch next from cTempLLP_Master into @Num_Proc_Master
						
						While @@Fetch_Status=0
						Begin
							Begin
								update LLP_Master 
								set 
									ETD_Master = ETD,
									LLP_Master.ATD_Master = ATD
								from LLP_Master LLP
								Join viagem_llp V with(nolock) on  V.ID_Viagem = LLP.ID_Viagem
								where V.ID_Viagem = @ID_Viagem and LLP.Num_Proc_Master = @Num_Proc_Master 
							End				
							fetch next from cTempLLP_Master into @Num_Proc_Master
						End

						Close cTempLLP_Master
						deallocate cTempLLP_Master
					End			
	   		End
	END
	
	
	BEGIN
		Insert 
			Log_Viagem_LLP 
			(id_viagem,id_navio,modal,nr_viagem,Cd_Dst,ETD,ATD,ETA,ATA,ativo,dt_ins,cd_usuario,Ano_viagem,id_op,manifesto,Notes,Id_Terminal)
		Values
			(@NID_Viagem,@id_navio,@Modal,@NR_Viagem,@cd_dst,@ETD,@ATD,@ETA,@ATA,@ativo,GETDATE(),@cd_usuario,@Ano_Viagem,@id_op,@Manifesto,@Notes,@Cd_Terminal)
	END
		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
