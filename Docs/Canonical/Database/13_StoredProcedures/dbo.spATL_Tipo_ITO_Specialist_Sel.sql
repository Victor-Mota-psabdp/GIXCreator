SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_ITO_Specialist
CREATE procedure [dbo].[spATL_Tipo_ITO_Specialist_Sel]
(
	@ID_TP_ITO_Specialist	BIGINT,
	@NOME_TP_ITO_Specialist varchar(100),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' 
	Begin
		select 
			ID_TP_ITO_Specialist [Code], NOME_TP_ITO_Specialist [Nome ITO Specialist],Ativo,Nome_Usuario,dt_ins [Data]
		from Tipo_ITO_Specialist T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			ID_TP_ITO_Specialist [Code], NOME_TP_ITO_Specialist [Nome ITO Specialist],Ativo,Nome_Usuario,dt_ins [Data] 
		from Tipo_ITO_Specialist T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ativo = 1
	End

if @Tipo = 'C'
	Begin
		select 
			ID_TP_ITO_Specialist [Code], NOME_TP_ITO_Specialist [Nome ITO Specialist],Ativo,Nome_Usuario,dt_ins [Data] 
		from Tipo_ITO_Specialist T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ID_TP_ITO_Specialist = @ID_TP_ITO_Specialist and
			ativo = 1
	End
if @Tipo = 'D'
	Begin
		select 
			ID_TP_ITO_Specialist [Code], NOME_TP_ITO_Specialist [Nome ITO Specialist],Ativo,Nome_Usuario,dt_ins [Data] 
		from Tipo_ITO_Specialist T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ID_TP_ITO_Specialist = @ID_TP_ITO_Specialist and
			ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			ID_TP_ITO_Specialist [Code], NOME_TP_ITO_Specialist [Nome ITO Specialist],Ativo,Nome_Usuario,dt_ins [Data] 
		from Tipo_ITO_Specialist T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			NOME_TP_ITO_Specialist = @NOME_TP_ITO_Specialist
	End
	
if @Tipo = 'O'
	Begin
		select 
			ID_TP_ITO_Specialist [Code], NOME_TP_ITO_Specialist [Nome ITO Specialist],Ativo,Nome_Usuario,dt_ins [Data] 
		from Tipo_ITO_Specialist T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			NOME_TP_ITO_Specialist = @NOME_TP_ITO_Specialist and
			ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			ID_TP_ITO_Specialist [Code], NOME_TP_ITO_Specialist [Nome ITO Specialist],Ativo,Nome_Usuario,dt_ins [Data] 
		from Tipo_ITO_Specialist T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			NOME_TP_ITO_Specialist = @NOME_TP_ITO_Specialist
			AND ID_TP_ITO_Specialist <> @ID_TP_ITO_Specialist
	End
	


	
GO
