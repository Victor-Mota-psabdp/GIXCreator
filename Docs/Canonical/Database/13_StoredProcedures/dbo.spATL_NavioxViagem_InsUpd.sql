SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Incluido @Terminal - 21/06/2017
--incluido veriricar se ja existe o navio x viagem x destino
--incluido o looping 17-8-2017 cadu



CREATE procedure [dbo].[spATL_NavioxViagem_InsUpd]

@Codigo			int,
@Nome_Navio		varchar(25),
@NR_Viagem		varchar(8),
@Ano_Viagem		int,
@Destino		varchar(30),
@Operador		varchar(30),
@Terminal		varchar(30),
@ETD			datetime,
@ATD			datetime,
@ETA			datetime,
@ATA			datetime,
@Manifesto		varchar(11),
@cd_usuario		Varchar(6),
@Notes			varchar(200),
@ativo			bit,
@Modal			varchar(1),
@NCodigo		int output

AS

Declare @cod int
Declare @cd_dst as varchar(3)
Declare @id_op as int
Declare @Id_Terminal as varchar(3)
Declare @id_navio as int
Declare @Num_Proc varchar(16)
Declare @Num_Proc_Master varchar(16)

set @cd_dst = (select cd_local from Localidade with(nolock) where Nome_Local =@Destino)
set @id_op = (select id_op from Tipo_Operador_Portuario with(nolock) where Descricao_OP =@Operador)
set @Id_Terminal = (select Cd_Terminal from Terminal with(nolock) where Nome_Terminal =@Terminal)
set @id_navio = (select id_navio from Navio_LLP with(nolock) where Nome_Navio =@Nome_Navio)

set @codigo = (select id_viagem from Viagem_LLP where ID_Navio = @id_navio and nr_viagem = @NR_Viagem and Cd_Dst = @cd_dst and Modal = @Modal)
print @codigo
Begin Transaction 
	IF @codigo is null 
	   BEGIN	
	   print 'INSERT'
		Set @cod=(select isnull(max(id_viagem),0)+1 from Viagem_LLP)
		print @cod
		Insert 
			Viagem_LLP (id_viagem,id_navio,modal,nr_viagem,Cd_Dst,ETD,ATD,ETA,ATA,ativo,dt_ins,cd_usuario,Ano_viagem,id_op,manifesto,Notes,Id_Terminal)
		Values
						(@cod,@id_navio,@Modal,@NR_Viagem,@cd_dst,@ETD,@ATD,@ETA,@ATA,1,GETDATE(),@cd_usuario,@Ano_Viagem,@id_op,@Manifesto,@Notes,@Id_Terminal)
			Set @NCodigo = @cod			
	   END
	ELSE
	   BEGIN
		if exists(select id_viagem from viagem_llp where id_viagem=@codigo)
			Begin
			print 'UPDATE'
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
					Id_Terminal = @Id_Terminal			
				Where
					ID_Viagem=@codigo
					Set @NCodigo = @codigo
					
					
			if @Modal = 'I'
				Begin
					--LLP_Imp_Mar
					Declare cTempLLP_Imp_Mar Cursor for
					(
						select Num_Proc_Lim from LLP_Imp_Mar with(nolock) where ID_Viagem = @codigo 
					)
					open cTempLLP_Imp_Mar
						fetch next from cTempLLP_Imp_Mar into @Num_proc					
							While @@Fetch_Status=0
								Begin
									Begin
										update LLP_Imp_Mar 
											set ETA_Lim = ETA,ATA_Lim = ATA from LLP_Imp_Mar LLP
											Join viagem_llp V with(nolock) on  V.ID_Viagem = LLP.ID_Viagem
											where V.ID_Viagem = @codigo	and LLP.Num_Proc_Lim = 	@Num_proc
									End	
									Begin
										Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus, ExcDtEnvio) 
										values (@Num_Proc, getdate(), 0, GETDATE())
									End	

									fetch next from cTempLLP_Imp_Mar into @Num_proc
								End
					Close cTempLLP_Imp_Mar
					deallocate cTempLLP_Imp_Mar
					
					--LLP_Master				
					Declare cTempLLP_Master Cursor for
					(
						select Num_Proc_Master from LLP_Master with(nolock) where ID_Viagem = @codigo 
					)
					open cTempLLP_Master
					fetch next from cTempLLP_Master into @Num_Proc_Master					
						While @@Fetch_Status=0
						Begin
							Begin
								update LLP_Master						
								set ETA_Master = ETA,ATA_Master = ATA from LLP_Master LLP
								Join viagem_llp V with(nolock) on  V.ID_Viagem = LLP.ID_Viagem
								where V.ID_Viagem = @codigo and llp.Num_Proc_Master = @Num_Proc_Master 
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
						select Num_Proc_Lem from LLP_Exp_Mar with(nolock) where ID_Viagem = @codigo 
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
								where V.ID_Viagem = @codigo and LLP.Num_Proc_Lem = @Num_Proc
							End	
							Begin
								Insert Into Exchange (ExcProcesso, ExcDataAlt, ExcStatus, ExcDtEnvio) 
								values (@Num_Proc, getdate(), 0, GETDATE())
							End

							fetch next from cTempLLP_Exp_Mar into @Num_proc
						End
					Close cTempLLP_Exp_Mar
					deallocate cTempLLP_Exp_Mar
					
					--LLP_Master				
					Declare cTempLLP_Master Cursor for
					(
						select Num_Proc_Master from LLP_Master where ID_Viagem = @codigo 
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
							where V.ID_Viagem = @codigo and LLP.Num_Proc_Master = @Num_Proc_Master 
						End				
						fetch next from cTempLLP_Master into @Num_Proc_Master
					End

					Close cTempLLP_Master
					deallocate cTempLLP_Master
				End	
				
				
				--if @Modal = 'I'
				--	Begin
				--		update LLP_Imp_Mar 
				--		--set ETD_Lim = ETD,ETA_Lim = ETA,ATD_lim = ATD, ATA_Lim = ATA from LLP_Imp_Mar LLP
				--		set ETA_Lim = ETA,ATA_Lim = ATA from LLP_Imp_Mar LLP
				--		Join viagem_llp V with(nolock) on  V.ID_Viagem = LLP.ID_Viagem
				--		where V.ID_Viagem = @codigo
					
				--		update LLP_Master 
				--		--set ETD_Lim = ETD,ETA_Lim = ETA,ATD_lim = ATD, ATA_Lim = ATA from LLP_Imp_Mar LLP
				--		set ETA_Master = ETA,ATA_Master = ATA from LLP_Master LLP
				--		Join viagem_llp V with(nolock) on  V.ID_Viagem = LLP.ID_Viagem
				--		where V.ID_Viagem = @codigo
				--	End
				--else if @Modal = 'E'
				--	Begin
				--		update LLP_Exp_Mar 
				--		--set ETD_Lim = ETD,ETA_Lim = ETA,ATD_lim = ATD, ATA_Lim = ATA from LLP_Imp_Mar LLP
				--		set 
				--			ETD_Lem = ETD,
				--			ATD_Lem = ATD,
				--			Cd_Terminal = Id_Terminal
				--			--ETA_Lem = ETA 
				--		from LLP_Exp_Mar LLP
				--		Join viagem_llp V with(nolock) on  V.ID_Viagem = LLP.ID_Viagem
				--		where V.ID_Viagem = @codigo
						
				--		update LLP_Master 
				--		--set ETD_Lim = ETD,ETA_Lim = ETA,ATD_lim = ATD, ATA_Lim = ATA from LLP_Imp_Mar LLP
				--		set 
				--			ETD_Master = ETD,
				--			LLP_Master.ATD_Master = ATD
				--			--ETA_Lem = ETA 
				--		from LLP_Master LLP
				--		Join viagem_llp V with(nolock) on  V.ID_Viagem = LLP.ID_Viagem
				--		where V.ID_Viagem = @codigo
				--	End
				
	   			End

	END
	
	
	BEGIN
	print 'LOG'
		Insert 
			Log_Viagem_LLP 
			(id_viagem,id_navio,modal,nr_viagem,Cd_Dst,ETD,ATD,ETA,ATA,ativo,dt_ins,cd_usuario,Ano_viagem,id_op,manifesto,Notes,Id_Terminal)
		Values
			(@NCodigo,@id_navio,@Modal,@NR_Viagem,@cd_dst,@ETD,@ATD,@ETA,@ATA,1,GETDATE(),@cd_usuario,@Ano_Viagem,@id_op,@Manifesto,@Notes,@Id_Terminal)
	END
		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
