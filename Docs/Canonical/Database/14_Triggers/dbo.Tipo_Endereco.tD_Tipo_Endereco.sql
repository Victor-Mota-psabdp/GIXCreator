SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE trigger [dbo].[tD_Tipo_Endereco] on [dbo].[Tipo_Endereco] for DELETE as
/* ERwin Builtin Thu Dec 27 21:30:04 2001 */
/* DELETE trigger on Tipo_Endereco */
begin
  declare  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Thu Dec 27 21:30:04 2001 */
    /* Tipo_Endereco R/15 Endereco ON PARENT DELETE RESTRICT */
    if exists (
      select * from deleted,Endereco
      where
        /*  Endereco.Cd_Tp_End = deleted.Cd_Tp_End */
        Endereco.Cd_Tp_End = deleted.Cd_Tp_End
    )
    begin
      select @errno  = 30001,
             @errmsg = 'Cannot DELETE Tipo_Endereco because Endereco exists.'
      goto error
    end
    /* ERwin Builtin Thu Dec 27 21:30:04 2001 */
    return
error:
	--Alessandra 26/03/2020 - corrigida sintaxe para esse SQL
    --raiserror @errno @errmsg
	raiserror (@errno, @errmsg, 1)
end

GO
ALTER TABLE [dbo].[Tipo_Endereco] ENABLE TRIGGER [tD_Tipo_Endereco]
GO
