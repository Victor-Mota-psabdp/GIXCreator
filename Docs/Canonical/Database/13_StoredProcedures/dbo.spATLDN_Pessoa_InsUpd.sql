SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATLDN_Pessoa_InsUpd]
(
	@Cd_Pes varchar(10),
	@Apelido varchar(20),
	@Nome_Raz_Soc varchar(60),
	@Num_CPF_CNPJ varchar(16),
	@Cd_Tp_Ativ char(3),
	@Cd_Tp_Grupo char(3),
	@Cd_Usuario VarChar(15),
	@Dt_Cad char(10),
	@Desat_Pes char(1),
	@Obs_Pes varchar(2000),
	@Num_RG_IE varchar(16),
	@Num_Insc_Munic		varchar(20)
	
	--@Cd_Tp_Classe		varchar(3),
	--@Cd_Cta_Ctb			varchar(13),
	--@Num_Insc_Munic		varchar(20),
	--@Cd_Tp_Pes			char(1),
	--@Dupl_Cta_Master	BIT,
	--@Email				varchar(75),	
	--@PgtoRcto			BIT,
	--@Group_Code			varchar(8),
	--@Global_Entity_Code	varchar(50),
	--@Global_Entity_ID	varchar(10)
)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Pessoa
	BEGIN TRY
		Declare @ID_New as varchar(10);

		set @Nome_Raz_Soc = left(@Nome_Raz_Soc,60)	
		set @Cd_Pes = (Select top 1 Cd_Pes from Pessoa with(nolock) where Apelido = @Apelido)
		
		IF EXISTS (select cd_pes from Pessoa with(nolock) where Cd_Pes = @Cd_Pes)	
			BEGIN
				Update 
					pessoa
				Set 
					apelido=@apelido,
					nome_raz_soc=@nome_raz_soc,
					num_cpf_cnpj=@num_cpf_cnpj,
					Num_Insc_Munic = @Num_Insc_Munic,
					cd_tp_ativ=@cd_tp_ativ,
					cd_tp_grupo=@cd_tp_grupo,
					cd_usuario=@cd_usuario,
					dt_cad=@dt_cad,
					Desat_Pes=@Desat_Pes,
					Obs_Pes=@Obs_Pes,
					Num_RG_IE=@Num_RG_IE
				Where
					Cd_Pes=@Cd_Pes				
			End
		ELSE
			BEGIN	
				Set @Cd_Pes=(select  isnull((max(right(cd_pes,9))),0)+1 from pessoa where left(cd_pes,1)='P' and len(cd_pes)=10)
				Set @Cd_Pes='P'+ right(('000000000' + @Cd_Pes),9)

				Insert Pessoa
					(Cd_Tp_Classe,cd_pes,apelido,nome_raz_soc,num_cpf_cnpj,cd_tp_ativ,cd_tp_grupo,cd_usuario,dt_cad, Desat_Pes,Obs_Pes,Num_RG_IE,Num_Insc_Munic)
				Values
					('GRL',@Cd_Pes,@apelido,@nome_raz_soc,@num_cpf_cnpj,@cd_tp_ativ,@cd_tp_grupo,@cd_usuario,@dt_cad,@Desat_Pes,@Obs_pes,@Num_RG_IE,@Num_Insc_Munic)				
			END	
		
		
		Select @Cd_Pes as Retorno;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
