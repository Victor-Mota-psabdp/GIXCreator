SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pPessoa_Upd 
(
@Cd_Pes			varchar(10), 
@Apelido			varchar(20), 
@Nome_Raz_Soc		varchar(60), 
@Num_CPF_CNPJ		varchar(15)='', 
@Num_RG_IE			varchar(30)='', 
@Cd_Tp_Ativ			varchar(3), 
@Cd_Tp_Classe		varchar(3), 
@Cd_Tp_Grupo			varchar(3), 
@Cd_Usuario			varchar(6),
@Cd_Cta_Ctb			varchar(13),
@Dt_Cad			varchar(10), 
@Desat_Pes			char(1),  
@Obs_Pes			varchar(2000)='',
@Num_Insc_Munic		varchar(20)= '', 
@Cd_Tp_Pes			char(1) = 'J',
@Cd_Usr_Resp			varchar(6) = null , 
@Email				varchar(75)='', 
@PgtoRcto			bit = 1
)
 AS
	If Exists(Select Apelido From Pessoa Where Cd_pes = @Cd_Pes)
		Begin 
			Update 
				Pessoa 
			Set 
				Apelido = @Apelido, 
				Nome_Raz_Soc = @Nome_Raz_Soc, 
				Num_CPF_CNPJ = @Num_CPF_CNPJ, 
				Num_RG_IE = @Num_RG_IE, 
				Cd_Tp_Ativ = @Cd_Tp_Ativ, 
				Cd_Tp_Classe = @Cd_Tp_Classe, 
				Cd_Tp_Grupo = @Cd_Tp_Grupo, 
				Cd_Usuario = @Cd_Usuario, 
				Cd_Cta_Ctb = @Cd_Cta_Ctb, 
				Dt_Cad = @Dt_Cad, 
				Desat_Pes = @Desat_Pes, 
				Obs_Pes = @Obs_Pes,
				Num_Insc_Munic = @Num_Insc_Munic,
				Cd_Tp_Pes = @Cd_Tp_Pes,
				Email = @Email,
				PgtoRcto = @PgtoRcto
			Where
				Cd_Pes = @Cd_Pes

			If @Cd_Usr_Resp <> null 
		
				Insert into
					Log_Pessoa 
					(Cd_Usr_Resp, Dt_Alt, Cd_Pes, Apelido, Nome_Raz_Soc, Num_CPF_CNPJ, Num_RG_IE, Cd_Tp_Ativ, Cd_Tp_Classe, Cd_Tp_Grupo, 
					Cd_Usuario, Cd_Cta_Ctb, Dt_Cad, Desat_Pes, Obs_Pes, Num_Insc_Munic, Cd_Tp_Pes)		
				Values 
					(@Cd_Usr_Resp, GetDate(), @Cd_Pes, @Apelido, @Nome_Raz_Soc, @Num_CPF_CNPJ, @Num_RG_IE, @Cd_Tp_Ativ, @Cd_Tp_Classe, 
					@Cd_Tp_Grupo, @Cd_Usuario, @Cd_Cta_Ctb, @Dt_Cad, @Desat_Pes,@Obs_Pes, @Num_Insc_Munic, @Cd_Tp_Pes)


			Return 1 

		End 
	
	Else
		Return -1
GO
