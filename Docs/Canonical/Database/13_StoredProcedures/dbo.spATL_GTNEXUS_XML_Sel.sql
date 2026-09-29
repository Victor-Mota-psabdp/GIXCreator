SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help GTNEXUS_XML
CREATE PROCEDURE [dbo].[spATL_GTNEXUS_XML_Sel]
(
	@ID_Smart			int,	
	@Num_Proc			varchar(16),
	@Type				varchar(2),
	@Tipo				char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin			
		select 			
			E.ID_Smart							[Id], 
			E.Id_GTNexus						[Id_GTNexus],
			E.num_proc							[JOB],
			E.Type								[GIX Type Code],
			C.Nome_Tp_Gix						[GIX Type Name],
			E.XML_DOC							[XML_DOC],
			E.XML_DOC2							[XML_DOC2],			
			E.Nome_Arquivo						[File Name],
			E.Dt_Ins							[Insert Date],
			E.Dt_Envio							[Sent Date],

			GT.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			US.Email			[Email]
		from GTNEXUS_XML E  with(nolock)
			Join Tipo_Gix C with(nolock) on E.Type=C.Cd_Tp_Gix	
			left join exchange_GTNEXUS GT with(nolock) on GT.Type=C.Cd_Tp_Gix and GT.ID = E.ID_GTNEXUS and GT.Num_Proc = E.Num_Proc
			left join Usuario	US with(nolock) on US.Cd_Usuario = GT.Cd_Usuario
		where
			E.ID_Smart = @ID_Smart
			and E.Dt_Envio is null
			
	End
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
			select 			
			E.ID_Smart							[Id], 
			E.Id_GTNexus						[Id_GTNexus],
			E.num_proc							[JOB],
			E.Type								[GIX Type Code],
			C.Nome_Tp_Gix						[GIX Type Name],
			E.XML_DOC							[XML_DOC],
			E.XML_DOC2							[XML_DOC2],			
			E.Nome_Arquivo						[File Name],
			E.Dt_Ins							[Insert Date],
			E.Dt_Envio							[Sent Date],

			GT.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			US.Email			[Email]
		from GTNEXUS_XML E  with(nolock)
			Join Tipo_Gix C with(nolock) on E.Type=C.Cd_Tp_Gix	
			left join exchange_GTNEXUS GT with(nolock) on GT.Type=C.Cd_Tp_Gix and GT.ID = E.ID_GTNEXUS and GT.Num_Proc = E.Num_Proc
			left join Usuario	US with(nolock) on US.Cd_Usuario = GT.Cd_Usuario
		where
			E.Type = @Type
			and E.Dt_Envio is null        
	
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 			
			E.ID_Smart							[Id], 
			E.Id_GTNexus						[Id_GTNexus],
			E.num_proc							[JOB],
			E.Type								[GIX Type Code],
			C.Nome_Tp_Gix						[GIX Type Name],
			E.XML_DOC							[XML_DOC],
			E.XML_DOC2							[XML_DOC2],			
			E.Nome_Arquivo						[File Name],
			E.Dt_Ins							[Insert Date],
			E.Dt_Envio							[Sent Date],

			GT.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			US.Email			[Email]
		from GTNEXUS_XML E  with(nolock)
			Join Tipo_Gix C with(nolock) on E.Type=C.Cd_Tp_Gix	
			left join exchange_GTNEXUS GT with(nolock) on GT.Type=C.Cd_Tp_Gix and GT.ID = E.ID_GTNEXUS and GT.Num_Proc = E.Num_Proc
			left join Usuario	US with(nolock) on US.Cd_Usuario = GT.Cd_Usuario			
		where
			E.ID_Smart = @ID_Smart
			and E.Num_Proc = @Num_Proc		
	End	

	

	
/*	
select 			
	E.ID_Smart							[Id], 
	E.Id_GTNexus						[Id_GTNexus],
	E.num_proc							[JOB],
	E.Type								[GIX Type Code],
	C.Nome_Tp_Gix						[GIX Type Name],
	E.XML_DOC							[XML_DOC],
	E.Nome_Arquivo						[File Name],
	E.Dt_Ins							[Insert Date],
	E.Dt_Envio							[Sent Date]
from GTNEXUS_XML E  with(nolock)
	Join Tipo_Gix C with(nolock) on E.Type=C.Cd_Tp_Gix	
	*/

----sp_help GTNEXUS_XML
--ALTER PROCEDURE [dbo].[spATL_GTNEXUS_XML_Sel]
--(
--	@ID_Smart			int,	
--	@Num_Proc			varchar(16),
--	@Type				varchar(2),
--	@Tipo				char(1)
--)
--as

--/*
--A, /// Todos os registros - Existentes
--B, /// Todos os registros - Ativos
--C, /// Busca pelo Codigo - Existentes
--D, /// Busca pelo Codigo - Ativos
--N, /// Busca pelo Nome - Existentes
--O /// Busca pelo Nome - Ativos
--Z /// Verifica Nome X Codigo
--*/

--if @Tipo = 'A' or @Tipo = 'B'
--	Begin			
--		select 			
--			E.ID_Smart							[Id], 
--			E.Id_GTNexus						[Id_GTNexus],
--			E.num_proc							[JOB],
--			E.Type								[GIX Type Code],
--			C.Nome_Tp_Gix						[GIX Type Name],
--			E.XML_DOC							[XML_DOC],
--			E.XML_DOC2							[XML_DOC2],			
--			E.Nome_Arquivo						[File Name],
--			E.Dt_Ins							[Insert Date],
--			E.Dt_Envio							[Sent Date],

--			GT.Cd_Usuario		[User Code],
--			US.Nome_Usuario		[User Name],
--			US.Email			[Email]
--		from GTNEXUS_XML E  with(nolock)
--			Join Tipo_Gix C with(nolock) on E.Type=C.Cd_Tp_Gix	
--			left join exchange_GTNEXUS GT with(nolock) on GT.Type=C.Cd_Tp_Gix and GT.ID = E.ID_GTNEXUS and GT.Num_Proc = E.Num_Proc
--			left join Usuario	US with(nolock) on US.Cd_Usuario = GT.Cd_Usuario
--		where
--			E.ID_Smart = @ID_Smart
--			and E.Dt_Envio is null
			
--	End
	
--if @Tipo = 'C' or @Tipo = 'D'
--	Begin
--			select 			
--			E.ID_Smart							[Id], 
--			E.Id_GTNexus						[Id_GTNexus],
--			E.num_proc							[JOB],
--			E.Type								[GIX Type Code],
--			C.Nome_Tp_Gix						[GIX Type Name],
--			E.XML_DOC							[XML_DOC],
--			E.XML_DOC2							[XML_DOC2],			
--			E.Nome_Arquivo						[File Name],
--			E.Dt_Ins							[Insert Date],
--			E.Dt_Envio							[Sent Date],

--			GT.Cd_Usuario		[User Code],
--			US.Nome_Usuario		[User Name],
--			US.Email			[Email]
--		from GTNEXUS_XML E  with(nolock)
--			Join Tipo_Gix C with(nolock) on E.Type=C.Cd_Tp_Gix	
--			left join exchange_GTNEXUS GT with(nolock) on GT.Type=C.Cd_Tp_Gix and GT.ID = E.ID_GTNEXUS and GT.Num_Proc = E.Num_Proc
--			left join Usuario	US with(nolock) on US.Cd_Usuario = GT.Cd_Usuario
--		where
--			E.Type = @Type
--			and E.Dt_Envio is null        
	
--	End

--if @Tipo = 'N' or @Tipo = 'O'
--	Begin
--		select 			
--			E.ID_Smart							[Id], 
--			E.Id_GTNexus						[Id_GTNexus],
--			E.num_proc							[JOB],
--			E.Type								[GIX Type Code],
--			C.Nome_Tp_Gix						[GIX Type Name],
--			E.XML_DOC							[XML_DOC],
--			E.XML_DOC2							[XML_DOC2],			
--			E.Nome_Arquivo						[File Name],
--			E.Dt_Ins							[Insert Date],
--			E.Dt_Envio							[Sent Date],

--			GT.Cd_Usuario		[User Code],
--			US.Nome_Usuario		[User Name],
--			US.Email			[Email]
--		from GTNEXUS_XML E  with(nolock)
--			Join Tipo_Gix C with(nolock) on E.Type=C.Cd_Tp_Gix	
--			left join exchange_GTNEXUS GT with(nolock) on GT.Type=C.Cd_Tp_Gix and GT.ID = E.ID_GTNEXUS and GT.Num_Proc = E.Num_Proc
--			left join Usuario	US with(nolock) on US.Cd_Usuario = GT.Cd_Usuario			
--		where
--			E.ID_Smart = @ID_Smart
--			and E.Num_Proc = @Num_Proc		
--	End	

	

	
--/*	
--select 			
--	E.ID_Smart							[Id], 
--	E.Id_GTNexus						[Id_GTNexus],
--	E.num_proc							[JOB],
--	E.Type								[GIX Type Code],
--	C.Nome_Tp_Gix						[GIX Type Name],
--	E.XML_DOC							[XML_DOC],
--	E.Nome_Arquivo						[File Name],
--	E.Dt_Ins							[Insert Date],
--	E.Dt_Envio							[Sent Date]
--from GTNEXUS_XML E  with(nolock)
--	Join Tipo_Gix C with(nolock) on E.Type=C.Cd_Tp_Gix	
--	*/
GO
