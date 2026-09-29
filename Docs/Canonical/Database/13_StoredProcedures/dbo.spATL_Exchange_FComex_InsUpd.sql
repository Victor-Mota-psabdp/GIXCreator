SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_Exchange_FComex_InsUpd]
		@Exchange_id bigint,
        @Num_Proc   varchar(16),
        @Lido_Processo bit,
        @Dt_Leitura_Processo datetime,
		@Dt_Fim_Processo datetime,
		@Id_Empresa bigint,
	    @Processo   varchar(16),
		@Tipo		varchar(1)
AS
/* Tipo de Processo 
   P processos 
   D documentos 
*/

Begin Transaction
if @Tipo = 'P'
		begin 
				If  exists (select Num_Proc from ATL_INT.dbo.Exchange_FComex where Num_Proc = trim(@Num_Proc))
					Begin
						Update
							ATL_INT.dbo.Exchange_FComex set 
							Lido_Processo = @Lido_Processo,
							Dt_Leitura_Processo =getdate(),
							Id_Empresa = @Id_Empresa,
							processo = trim(@processo)
						Where
							Num_Proc = trim(@Num_Proc) 
					End
				Else
					Begin	
                        if len(trim(@Num_Proc))=16
						    Begin 
							   Insert
								  ATL_INT.dbo.Exchange_FComex 
							   Values			
							 	 (trim(@Num_Proc),@Lido_Processo,getdate(),null,@Id_Empresa,trim(@Processo))
						   End 
				    End
		end 
else
if @Tipo = 'D'
   begin 
				If  exists (select Num_Proc from ATL_INT.dbo.Exchange_FComex where Num_Proc = trim(@Num_Proc)) 
					Begin
						Update
							ATL_INT.dbo.Exchange_FComex set 
							Dt_Fim_Processo =@Dt_Fim_Processo,
							Lido_Processo = @Lido_Processo,
							Dt_Leitura_Processo = getdate(),
							Id_Empresa =@Id_Empresa,
							processo = trim(@processo)
						Where
							Num_Proc = trim(@Num_Proc) 
					End
   end 

if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction
GO
