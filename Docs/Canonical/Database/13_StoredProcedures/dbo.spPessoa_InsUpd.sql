SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Em 27-05-2010
Alteração para utilizar as 10 posições do CD_PES, pois estavamos tendo problema de inserção
passamos a inserir cd_pes = 'P000000001'

select * from pessoa where len(cd_pes)=10 and  left(cd_pes,1)='P'
Em 8-7-2013 nao deixar alterar o cnpj - AX

em 21/11/2014 - incluido o log_pessoa_new
*/

CREATE  procedure [dbo].[spPessoa_InsUpd]

@cd_pes varchar(10),
@Apelido varchar(20),
@Nome_Raz_Soc varchar(160),
@Num_CPF_CNPJ varchar(16),
@Cd_Tp_Ativ char(3),
@Cd_Tp_Grupo char(3),
@Cd_Usuario VarChar(15),
@Dt_Cad char(10),
@Desat_Pes char(1),
@Obs_Pes varchar(2000),
@Num_RG_IE varchar(16)

AS

Begin Transaction 
	Declare @Tp_Oper char(1)
	set @Nome_Raz_Soc = left(@Nome_Raz_Soc,60)
	
	set @Cd_Pes = (Select Cd_Pes from Pessoa with(nolock) where Apelido = @Apelido)
	
	IF @cd_pes is null 

	   BEGIN
		Set @Tp_Oper = 'I'
		Set @cd_pes=(select  isnull((max(right(cd_pes,9))),0)+1 from pessoa where left(cd_pes,1)='P' and len(cd_pes)=10)
		Set @cd_pes='P'+ right(('000000000' + @cd_pes),9)

		Insert 
			pessoa(Cd_Tp_Classe,cd_pes,apelido,nome_raz_soc,num_cpf_cnpj,cd_tp_ativ,cd_tp_grupo,cd_usuario,dt_cad, Desat_Pes,Obs_Pes,Num_RG_IE)
		Values
			('GRL',@cd_pes,@apelido,@nome_raz_soc,@num_cpf_cnpj,@cd_tp_ativ,@cd_tp_grupo,@cd_usuario,@dt_cad,@Desat_Pes,@Obs_pes,@Num_RG_IE)
	   END
	
	ELSE
	   BEGIN
		if exists(select cd_pes from pessoa where cd_pes=@cd_pes)
		Begin

			Update 
				pessoa
			Set 
				apelido=@apelido,
				nome_raz_soc=@nome_raz_soc,
--				num_cpf_cnpj=@num_cpf_cnpj,
				cd_tp_ativ=@cd_tp_ativ,
				cd_tp_grupo=@cd_tp_grupo,
				cd_usuario=@cd_usuario,
				dt_cad=@dt_cad,
				Desat_Pes=@Desat_Pes,
				Obs_Pes=@Obs_Pes,
				Num_RG_IE=@Num_RG_IE
			Where
				cd_pes=@cd_pes
			
			if @Desat_Pes = 'S'	
				Set @Tp_Oper = 'D'
			else
				Set @Tp_Oper = 'U'
	   	End
	   	
	   	
	   	Insert into
			Log_Pessoa_New
			(Cd_Usuario, Dt_Ins, Tp_Oper, Cd_Pes, Apelido, Nome_Raz_Soc, Num_CPF_CNPJ, Num_RG_IE, 
			cd_Tp_Ativ,	Cd_Tp_Grupo, 
			Dt_Cad, Desat_Pes, Obs_Pes,PgtoRcto)		
		Values 
			(@Cd_Usuario, GetDate(),@Tp_Oper ,@Cd_Pes, @Apelido, @Nome_Raz_Soc, @Num_CPF_CNPJ, @Num_RG_IE, 
			@Cd_Tp_Ativ, @Cd_Tp_Grupo, 
			@Dt_Cad, @Desat_Pes,@Obs_Pes,1)
	   	
		if @@rowcount = 0 
			return -1
END
Commit Transaction 
	
















GO
