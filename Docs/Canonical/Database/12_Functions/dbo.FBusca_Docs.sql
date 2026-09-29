SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FBusca_Docs]
(
@processo varchar(16),
@id_dc    int
)
RETURNS varchar(3)
AS
BEGIN
	
	Declare @resultado varchar(3)
	
	if exists (select num_proc from doc_anexos with(nolock) where num_proc=@processo and id_dc=@id_Dc)
		begin
			set @resultado = 'SIM'
		end 
	else
		begin 
			set @resultado = 'NÃO'
		end
	
	RETURN @resultado

END

GO
